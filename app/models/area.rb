require 'date'
require 'set'
class Area < ActiveRecord::Base
  has_and_belongs_to_many :observations, :order => 'obs_date desc'
  belongs_to :study
  belongs_to :treatment
  
  validates_uniqueness_of :name, :case_sensitive => false, :message => "must be unique"
  validate :no_treatment_without_study
  validate :treatment_is_part_of_study
  validate :name_has_no_spaces

  # Area.parse returns an array of arrays if the parse was successful
  # otherwise it returns the text with the offendinng token highlighted by **
  # for example  'T1R1 R11' will return  'T1R1 *R11*' 
  def Area.parse(areas_as_text)
    tokens = areas_as_text.chomp.split(/ +/)
    areas = tokens.collect {|token| get_areas_by_token(token)}
    areas.flatten!

    # if areas contains a string
    if (areas.any? {|area| area.class.name  == 'String'})
      stringify_areas(areas)
    else
      areas
    end
  end

   
  # an implementation of unparse() that is more general.
  # Should work on all studies, should not make assumptions about the number of reps.  
  def Area.unparse2(areas=[])
  	# prefixes = ["T", "B", "F", "iF", "REPT"]
  	tokens = []
  	studies = areas.collect{|a| a.study}.uniq  # list of study numbers
  	# why not do a Study.all ?
  	# also remember that not every area belongs to a study
  	
  	# the query set (is subset?)
	  areas_set = areas.to_set	
	  	
	  studies.each do |s|
	  	study_set = s.areas.to_set
	  	if !study_set.empty? && study_set.subset?(areas_set)
	  		areas_set -= study_set
	  		tokens << s.name
	  	end # if
	  	
	  	s.treatments.each do |t|
	  		treatment_set = t.areas.to_set
	  		if !treatment_set.empty? && treatment_set.subset?(areas_set)
	  			areas_set -= treatment_set
	  			tokens << t.name
	  		end # if
	  	end # s.treatments.each
	  end # studies.each
	  
	  if !areas_set.empty?
	    remaining = areas_set.to_a.sort
			tokens << remaining.collect{|r| r.name}
		end
	  
	  tokens.flatten.join(' ')
  
  end
  
  def Area.unparse(areas=[])
    areas = areas.collect {|area| area.name.to_sym}
    areas = areas.to_set

    studies = Study.all
    
    studies.each do | study |
      study.treatments.each do |treatment|
        areas = reduce_names(areas, treatment.name, treatment.areas)
      end
      areas = reduce_names(areas, study.name, study.treatments)
    end
    
  	areas = areas.collect {|area| area.to_s}.sort
    areas.join(' ')
  end

  def <=>(other)
  	if self.study_id != other.study_id
  		self.study_id <=> other.study_id  # could use study.name
  	else
  	# invariant: self.study_id == other.study_id
  		if self.treatment_id != other.treatment_id
  			self.treatment_id <=> other.treatment_id
  		else
  			# invariant: self.study_id == other.study_id && self.treatment == other.treatment
  			self.replicate <=> other.replicate
  		end
  	end	# if self.study != other.study
  end	# def <=>(other)
  
  
  private##########################################

  def no_treatment_without_study
    # area without study is OK
  	if :study_id.nil? && ! :treatment_id.nil?
  		errors.add(:base, 'No treatment allowed if study is nil')
  	end
  end

  def treatment_is_part_of_study
    # if treatment exists then it must belong to correct study
    errors.add(:base, 'inconsistent study and treatment combination') unless  treatment.nil? || (treatment.study_id == study_id)
  end

  def name_has_no_spaces
    errors.add(:base, 'names should not contain spaces') if name && name.scan(/ /) != []
  end


  def Area.stringify_areas(areas)
    area_strings = areas.collect do |area|
      if (area.class.name == 'String')
        "*"+area+"*"
      else
        area.name
      end
    end
    area_strings.join(' ')
  end

  def Area.get_areas_by_token(token)
    case token
      #specify the whole main site
    when /^MAIN$/
      study = 1
      #specify a whole treatment
    when  /^[t|T]([1-8])$/
      treatment_number = $1
      study = 1
      #specify a whole rep
    when /^[r|R]([1-6])$/
      replicate = $1
      study = 1
      #specify a range of treatments
    when /^[t|T]([1-8])\-([1-8])$/
      treatment_number = $1..$2
      study = 1
      #specify a treatment except a rep
    when /^[t|T]([1-8])\![r|R]([1-6])$/ then area = Area.where(['treatment_number = ? and not replicate = ? and study_id = 1',$1, $2])
      #specify a replicate except a treatment
    when /^[r|R]([1-6])\![t|T]([1-8])$/ then area = Area.where(['replicate = ? and not treatment_number = ? and study_id = 1', $1,$2])
      #specify Biodiversity Plots
    when /^[b|B]([1-9]|1[0-9]|2[0-1])$/
      treatment_number = $1
      study = 2
      #specify N fert
    when /^Fertility_Gradient$/, /^[f|F]([1-9])$/
      study = 3
      treatment_number = $1
    when /^[f|F]([1-9])-([1-9])$/
      treatment_number = $1..$2
      study = 3
    when /^Irrigated_Fertility_Gradient$/, /^i[f|F]([1-9])$/
      study = 4
      treatment_number = $1
    when /^i[f|F]([1-9])-([1-9])$/
      study = 4
      treatment_number = $1..$2
    when /^[r|R][e|E][p|P][t|T]([1-4])[E|e]([1-3])$/
      treatment_number = [$1,$2].join
      study = 5
      # specify GLRBC plots
    when /^GLBRC$/
      study = 6
      # specify Cellulosic energy study
    when /^CES$/, /^[ce|CE|Ce|cE]([1-9]|1[0-9])$/
      study = 7
      treatment_number = $1
    end
    if study 
      if treatment_number
        if replicate
          area = Area.find_all_by_study_id_and_treatment_number_and_replicate(study, treatment_number, replicate)
        else
          area = Area.find_all_by_study_id_and_treatment_number(study, treatment_number)
        end
      else
        area = Area.find_all_by_study_id(study)
      end
    end
    if area.blank?
      # try to find an area by name
      area = Area.where(['upper(name) = ?', token.squeeze.upcase])
    end
    if area.blank?
      token
    else
      area
    end
  end

  def Area.reduce_names(areas,name,collection)
    test = collection.collect {|member| member.name.to_sym}
    test = test.to_set
    if !test.empty? && areas.superset?(test)
      areas -= test
      areas << name.to_sym
    end
    return areas
  end
end
