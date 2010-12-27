require 'date'
require 'set'
class Area < ActiveRecord::Base
  attr_accessible :name, :treatment_number, :replicate, :study_id,
                  :treatment_id, :description

  has_and_belongs_to_many :observations, :order => 'obs_date desc'
  belongs_to :study
  belongs_to :treatment
  
  validates :name, :uniqueness => { :case_sensitive => false }
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
  	if treatment_id? && !study_id?
  		errors.add(:base, 'No treatment allowed if study is nil')
  	end
  end

  def treatment_is_part_of_study
    # if treatment exists then it must belong to correct study
    if treatment && (treatment.study_id != study_id)
      errors.add(:base, 'inconsistent study and treatment combination')
    end
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
    area = case token
    when /^MAIN$/ #specify the whole main site
      Area.where(:study_id => 1)
    when /^[t|T]([1-8])$/ #specify a whole treatment
      Area.where(:study_id => 1, :treatment_number => $1)
    when /^[r|R]([1-6])$/ #specify a whole rep
      Area.where(:study_id => 1, :replicate => $1)
    when /^[t|T]([1-8])\-([1-8])$/ #specify a range of treatments
      Area.where(:study_id => 1, :treatment_number => $1..$2)
    when /^[t|T]([1-8])\![r|R]([1-6])$/ #specify a treatment except a rep
      Area.where(:study_id => 1, :treatment_number => $1).where(['not replicate = ?',$2])
    when /^[r|R]([1-6])\![t|T]([1-8])$/ #specify a replicate except a treatment
      Area.where(:study_id => 1, :replicate => $1).where(['not treatment_number = ?',$2])
    when /^[b|B]([1-9]|1[0-9]|2[0-1])$/ #specify Biodiversity Plots
      Area.where(:study_id => 2, :treatment_number => $1)
    when /^Fertility_Gradient$/, /^[f|F]([1-9])$/ #specify N fert
      Area.where(:study_id => 3, :treatment_number => $1)
    when /^[f|F]([1-9])-([1-9])$/
      Area.where(:study_id => 3, :treatment_number => $1..$2)
    when /^Irrigated_Fertility_Gradient$/, /^i[f|F]([1-9])$/
      Area.where(:study_id => 4, :treatment_number => $1)
    when /^i[f|F]([1-9])-([1-9])$/
      Area.where(:study_id => 4, :treatment_number => $1..$2)
    when /^[r|R][e|E][p|P][t|T]([1-4])[E|e]([1-3])$/
      Area.where(:study_id => 5, :treatment_number => [$1,$2].join)
    when /^GLBRC$/ # specify GLRBC plots
      Area.where(:study_id => 6)
    when /^CES$/, /^[ce|CE|Ce|cE]([1-9]|1[0-9])$/ # specify Cellulosic energy study
      Area.where(:study_id => 7, :treatment_number => $1)
    else
      nil
    end
    # try to find an area by name
    area = Area.where(['upper(name) = ?', token.squeeze.upcase]) if area.blank?
    area = token if area.blank? #failed to find an area
    area
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
