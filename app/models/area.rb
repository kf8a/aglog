require 'date'

# Represents a location where observations are done.
class Area < ActiveRecord::Base
  attr_accessible :name, :treatment_number, :replicate, :study_id,
                  :treatment_id, :description

  has_and_belongs_to_many :observations, :order => 'obs_date desc'
  belongs_to :study
  belongs_to :treatment
  
  validates :name, :uniqueness => { :case_sensitive => false }
  validates :study, :presence => { :if => :treatment_id }
  validate :treatment_is_part_of_study
  validate :name_has_no_spaces

  # Tries to find areas by their names.
  # @param [String] areas_as_text a string containing area names
  # @return [String or Array] the original string with errors highlighted or
  #   an array of areas
  # @example Parse a string of actual area names
  #   Area.parse('T1R1 T2') #=> [#<Area id: 1, name: "T1R1" ... >, ... ]
  # @example Parse a string which has no area with that name
  #   Area.parse('T1R1 R11') #=> "T1R1 *R11*"
  def Area.parse(areas_as_text)
    tokens = areas_as_text.chomp.split(/ +/)
    areas = tokens.collect {|token| get_areas_by_token(token)}
    areas.flatten!

    # if areas contains a string
    if (areas.any? { |area| area.class == String })
      stringify_areas(areas)
    else
      areas
    end
  end

    # Transforms an array of areas into a list of area names and study names if a
  # whole study's areas are included.
  # @param [Array] areas an array of areas
  # @return [String] a list of area names and study names if a whole study's
  #   areas are included (and treatment names for the same reason)
  def Area.unparse(areas = [])
    areas = areas.to_a
    studies, areas = replace_study_areas_by_study(areas)
    treatments, areas = replace_treatment_areas_by_treatment(areas)
    area_names = areas.compact.uniq.collect { |area| area.name }
    names = studies + treatments + area_names

    names.sort.join(' ')
  end

  private##########################################

  def Area.replace_study_areas_by_study(areas)
    # if all of a study's areas are here,
    # use the study's name instead of individual areas
    studies = []
    study_ids = areas.collect { |area| area.study_id }
    study_ids.compact.uniq.each do |study_id|
      study_areas = Area.where(:study_id => study_id).all
      if !study_areas.empty? && ([] == study_areas - areas)
        areas -= study_areas
        studies << Study.find(study_id).name
      end
    end

    [studies, areas]
  end

  def Area.replace_treatment_areas_by_treatment(areas)
    # if all of a treatment's areas are here,
    # use the treatment's name instead of individual areas
    treatments = []
    treatment_ids = areas.collect { |area| area.treatment_id }
    treatment_ids.compact.uniq.each do |treatment_id|
      treatment_areas = Area.where(:treatment_id => treatment_id).all
      if !treatment_areas.empty? && ([] == treatment_areas - areas)
        areas -= treatment_areas
        treatments << Treatment.find(treatment_id).name
      end
    end

    [treatments, areas]
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

end
