require 'date'

# Represents a location where observations are done.
class Area < ActiveRecord::Base
  attr_accessible :name, :treatment_number, :replicate, :study_id,
                  :treatment_id, :description

  has_and_belongs_to_many :observations, :order => 'obs_date desc'
  belongs_to :study
  belongs_to :treatment
  
  validates :name, :uniqueness => { :case_sensitive => false }
  validates :study, :presence => { :if => :study_id }
  
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
    areas = []
    tokens = areas_as_text.chomp.split(/ +/)
    tokens.each { |token| areas += get_areas_by_token(token) }

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
  def Area.unparse(areas = nil)
    areas = areas.to_a
    studies, areas = replace_class_areas_by_class(areas, Study)
    treatments, areas = replace_class_areas_by_class(areas, Treatment)
    treatment_numbers, areas = replace_treatment_number_areas_by_treatment_number(areas)
    area_names = areas.compact.uniq.collect { |area| area.name }
    names = studies + treatments + treatment_numbers + area_names

    names.sort.join(' ')
  end

  def study_name
    self.study.try(:name)
  end

  private##########################################

  def Area.replace_class_areas_by_class(areas, klass)
    members = []
    id_method = "#{klass.name.downcase}_id"
    member_ids = areas.collect { |area| area.send(id_method) }
    member_ids.compact.uniq.each do |member_id|
      member_areas = Area.where(id_method => member_id).all
      if areas.contains(member_areas)
        areas -= member_areas
        members << klass.find(member_id).name
      end
    end

    [members, areas]
  end

  def Area.replace_treatment_number_areas_by_treatment_number(areas)
    # if all of a treatment number's areas are here,
    # use the treatment's name instead of individual areas
    treatments = []
    treatment_and_studies = areas.collect { |area| [area.treatment_number, area.study_id] }

    treatment_and_studies.compact.uniq.each do |treatment_number, study_id|
      if treatment_number
        treatment_areas = Area.where(:treatment_number => treatment_number, :study_id => study_id).all
        if areas.contains(treatment_areas)
          areas -= treatment_areas
          name_to_include = treatment_areas[0].name.overlap(treatment_areas[-1].name)
          name_to_include.chomp!('r') or name_to_include.chomp!('R')
          treatments << name_to_include
        end
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
    errors.add(:base, 'names should not contain spaces') if name.to_s.include?(' ')
  end

  def Area.stringify_areas(areas)
    area_strings = areas.collect do |area|
      (area.class == String) ? "*#{area}*" : area.name
    end
    area_strings.join(' ')
  end

  def Area.get_areas_by_token(token)
    area = case token.upcase
    when /^MAIN$/ #specify the whole main site
      Area.where(:study_id => 1).all
    when /^T([1-8])$/ #specify a whole treatment
      Area.where(:study_id => 1, :treatment_number => $1).all
    when /^R([1-6])$/ #specify a whole rep
      Area.where(:study_id => 1, :replicate => $1).all
    when /^T([1-8])\-([1-8])$/ #specify a range of treatments
      Area.where(:study_id => 1, :treatment_number => $1..$2).all
    when /^T([1-8])\!R([1-6])$/ #specify a treatment except a rep
      Area.where(:study_id => 1, :treatment_number => $1).where(['not replicate = ?',$2]).all
    when /^R([1-6])\!T([1-8])$/ #specify a replicate except a treatment
      Area.where(:study_id => 1, :replicate => $1).where(['not treatment_number = ?',$2]).all
    when /^B([1-9]|1[0-9]|2[0-1])$/ #specify Biodiversity Plots
      Area.where(:study_id => 2, :treatment_number => $1).all
    when /^FERTILITY_GRADIENT$/
      Area.where(:study_id => 3).all
    when /^F([1-9])$/ #specify N fert
      Area.where(:study_id => 3, :treatment_number => $1).all
    when /^F([1-9])-([1-9])$/
      Area.where(:study_id => 3, :treatment_number => $1..$2).all
    when /^IRRIGATED_FERTILITY_GRADIENT$/
      Area.where(:study_id => 4).all
    when /^IF([1-9])$/
      Area.where(:study_id => 4, :treatment_number => $1).all
    when /^IF([1-9])-([1-9])$/
      Area.where(:study_id => 4, :treatment_number => $1..$2).all
    when /^REPT([1-4])E([1-3])$/
      Area.where(:study_id => 5, :treatment_number => [$1,$2].join).all
    when /^GLBRC$/ # specify GLRBC plots
      Area.where(:study_id => 6).all
    when /^CES$/ # specify Cellulosic energy study
      Area.where(:study_id => 7).all
    else
      nil
    end
    # try to find an area by name
    area = Area.where(['upper(name) = ?', token.squeeze.upcase]).all if area.blank?
    area = [token] if area.blank?
    area
  end

end

class Array
  def contains(other_array)
    [] == other_array - self
  end
end

class String
  def overlap(other_string)
    id = 0
    overlap = ''
    while self[id] && (self[id] == other_string[id])
      overlap += self[id].to_s
      id += 1
    end

    overlap
  end
end