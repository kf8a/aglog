require 'date'
require 'set'
class Area < ActiveRecord::Base
  has_and_belongs_to_many :observations, :order => 'obs_date desc'
#  has_many  :area_location
#  has_many  :locations, :through => :area_location
  belongs_to :study
  belongs_to :treatment
  
  validates_uniqueness_of :name, :case_sensitive => false, :message => "must be unique"
  
  # validates_presence_of :study, :allow_nil => true, :message => "must exist" 

  def validate
  	# area without study is OK
  	if :study_id.nil? && ! :treatment_id.nil?
  		errors.add('No treatment allowed if study is nil')
  	end
  	# if treatment exists then it must belong to correct study
    errors.add('inconsistent study and treatment combination') unless  treatment.nil? || (treatment.study_id == study_id)
    errors.add('names should not contain spaces') if name.scan(/ /) != []
  end
  
  # Area.parse returns an array of arrays if the parse was successful
  # otherwise it returns the text with the offendinng token highlighted by **
  # for example  'T1R1 R11' will return  'T1R1 *R11*' 
  def Area.parse(areas_as_text)
    tokens = areas_as_text.chomp.split(/ +/)
    areas = tokens.collect {|token| get_areas_by_token(token)}
    areas.flatten!

    # if areas contains a string
    if (areas.any? {|x| x.class.name  == 'String'})
      areas = areas.collect do |area|
        if (area.class.name == 'String')
          "*"+area+"*"
        else
          area.name
        end
      end
      areas = areas.join(' ')
    end

    areas
  end

   
  # an implementation of unparse() that is more general.
  # Should work on all studies, should not make assumptions about the number of reps.  
  def Area.unparse2(areas=[])
  	# prefixes = ["T", "B", "F", "iF", "REPT"]
  	tokens = []
  	studies = areas.collect{|a| a.study}.uniq  # list of study numbers
  	# why not do a Studies.find(:all) ?
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

    studies = Study.find(:all)
    
    studies.each do | study |
      study.treatments.each do |treatment|
        areas = reduce_names(areas, treatment.name, treatment.areas)
      end
      areas = reduce_names(areas, study.name, study.treatments)
    end
    
  	areas = areas.collect {|area| area.to_s}.sort
    areas.join(' ')
  end

  def location(date=Date.today)
    Locations.find(:first, :conditions => ['date <= ?',date], order => 'date DESC')
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
  
#  private
  
  def Area.reduce_names(areas,name,collection)
    test = collection.collect {|x| x.name.to_sym}
    test = test.to_set
    if !test.empty? && areas.superset?(test)
      areas -= test
      areas << name.to_sym
    end
    return areas
  end

  private

  def Area.get_areas_by_token(token)
    case token
      #specify the whole main site
    when /^MAIN$/
      Area.find_all_by_study_id(1)
      #specify a whole treatment
    when  /^[t|T]([1-8])$/
      treatment_number = $1
      study = 1
      Area.find_all_by_treatment_number_and_study_id(treatment_number, study)
      #specify a whole rep
    when /^[r|R]([1-6])$/
      replicate = $1
      study = 1
      Area.find_all_by_replicate_and_study_id(replicate, study)
      #specify a range of treatments
    when /^[t|T]([1-8])\-([1-8])$/
      treatment_number = $1
      replicate = $2
      study = 1
      Area.find_all_by_treatment_number_and_replicate_and_study_id(treatment_number, replicate, study)
      #specify a treatment except a rep
    when /^[t|T]([1-8])\![r|R]([1-6])$/ then  Area.find(:all, :conditions => ['treatment_number = ? and not replicate = ? and study_id = 1',$1, $2])
      #specify a replicate except a treatment
    when /^[r|R]([1-6])\![t|T]([1-8])$/ then Area.find(:all, :conditons => ['replicate = ? and not treatment_number = ? and study_id = 1', $1,$2])
      #specify Biodiversity Plots
    when /^[b|B]([1-9]|1[0-9]|2[0-1])$/
      treatment_number = $1
      study = 2
      Area.find_all_by_treatment_number_and_study_id(treatment_number, study)
      #specify N fert
    when /^Fertility_Gradient$/
      Area.find_all_by_study_id(3)
    when /^[f|F]([1-9])$/
      treatment_number = $1
      study = 3
      Area.find_all_by_treatment_number_and_study_id(treatment_number, study)
    when /^[f|F]([1-9])-([1-9])$/
      Area.find(:all, :conditions=> { :study_id => 3, :treatment_number => $1..$2 } )
    when /^Irrigated_Fertility_Gradient$/
      Area.find_all_by_study_id(4)
    when /^i[f|F]([1-9])$/
      treatment_number = $1
      study = 4
      Area.find_all_by_treatment_number_and_study_id(treatment_number, study)
    when /^i[f|F]([1-9])-([1-9])$/ then Area.find(:all, :conditions=>['study_id = 4 and treatment_number betwen ? and ?', $1,$2])
    when /^[r|R][e|E][p|P][t|T]([1-4])[E|e]([1-3])$/
      treatment_number = [$1,$2].join
      study = 5
      Area.find_all_by_treatment_number_and_study_id(treatment_number, study)
      # specify GLRBC plots
    when /^GLBRC$/
      Area.find_all_by_study_id(6)
    when /^[g|G](10|[1-9])[r|R]([1-6])$/
      treat = $1
      rep = $2
      Area.find_all_by_name("G#{treat}R#{rep}") +
        Area.find_all_by_name("G#{treat}r#{rep}") +
        Area.find_all_by_name("g#{treat}R#{rep}") +
        Area.find_all_by_name("g#{treat}r#{rep}")
    when /^[g|G](10|[1-9])$/
      number = $1
      Area.find_all_by_name("G#{number}") + Area.find_all_by_name("g#{number}")
      # specify Cellulosic energy study
    when /^CES$/
      Area.find_all_by_study_id(7)
    when /^[ce|CE|Ce|cE]([1-9]|1[0-9])$/
      treatment_number = $1
      study = 7
      Area.find_all_by_treatment_number_and_study_id(treatment_number, study)
    else
      # try to find an area by name
      area = Area.find(:all, :conditions => ['upper(name) = ?', token.squeeze.upcase])
      if area.blank?
        token
      else
        area
      end
    end
  end
end
