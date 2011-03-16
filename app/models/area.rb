require 'date'

# Represents a location where observations are done.
class Area < ActiveRecord::Base
  attr_accessible :name, :treatment_number, :replicate, :study_id,
                  :treatment_id, :description

  has_and_belongs_to_many :observations, :order => 'obs_date desc'
  belongs_to :study
  belongs_to :treatment
  belongs_to :company

  scope :by_company, lambda {|company| where(:company_id => company)}

  scope :main_study, where(:study_id => 1)
  scope :fert_study, where(:study_id => 3)
  scope :if_study, where(:study_id => 4)
  scope :ce_study, where(:study_id => 7)
  scope :glbrc_study, where(:study_id => 6)

  validates :name, :uniqueness => { :case_sensitive => false,
                                    :scope => :company_id }
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
    parser = AreaParser.new
    transformer = AreaParserTransform.new
    invalid_tokens = []
    begin
      area_tokens = transformer.apply(parser.parse(areas_as_text))
      areas = area_tokens.collect do |token|
        study_id = Study.find_by_name(token.delete(:study))
        area = Area.send(:where, token).where(:study_id => study_id).all
        invalid_tokens << token if area.empty?
        area
      end
    areas.flatten
    rescue Parslet::ParseFailed => error
      areas_as_text 
    end
  end

    # Transforms an array of areas into a list of area names and study names if a
  # whole study's areas are included.
  # @param [Array] areas an array of areas
  # @return [String] a list of area names and study names if a whole study's
  #   areas are included (and treatment names for the same reason)
  def Area.unparse(areas = [])
    names, areas = replace_class_areas_by_class([], areas, Study)
    names, areas = replace_class_areas_by_class(names, areas, Treatment)
    names, areas = replace_treatment_number_areas_by_treatment_number(names, areas)
    names += areas.uniq.collect { |area| area.name }

    names.sort.join(' ')
  end

  def study_name
    self.study.try(:name)
  end

  private##########################################

  def Area.replace_class_areas_by_class(names, areas, klass)
    id_method = "#{klass.name.downcase}_id"
    member_ids = areas.collect { |area| area.send(id_method) }
    member_ids.compact.uniq.each do |member_id|
      member_areas = Area.where(id_method => member_id).all
      if areas.contains(member_areas)
        areas -= member_areas
        names << klass.find(member_id).name
      end
    end

    [names, areas]
  end

  def Area.replace_treatment_number_areas_by_treatment_number(names, areas)
    # if all of a treatment number's areas are here,
    # use the treatment's name instead of individual areas
    treatment_and_studies = areas.collect { |area| [area.treatment_number, area.study_id] if area.treatment_number }

    treatment_and_studies.uniq.each do |treatment_number, study_id|
      treatment_areas = Area.where(:treatment_number => treatment_number, :study_id => study_id).all
      if areas.contains(treatment_areas)
        areas -= treatment_areas
        names << extract_treatment_name(treatment_areas)
      end
    end

    [names, areas]
  end

  def Area.extract_treatment_name(treatment_areas)
    name_to_include = treatment_areas[0].name.overlap(treatment_areas[-1].name)
    name_to_include.chomp!('r') or name_to_include.chomp!('R')

    name_to_include
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
      main_study
    when /^T(\d)$/ #specify a whole treatment
      main_study.where(:treatment_number => $1)
    when /^R(\d)$/ #specify a whole rep
      main_study.where(:replicate => $1)
    when /^T(\d)-(\d)$/ #specify a range of treatments
      main_study.where(:treatment_number => $1..$2)
    when /^T(\d)!R(\d)$/ #specify a treatment except a rep
      main_study.where(:treatment_number => $1).where('not replicate = ?',$2)
    when /^R(\d)!T(\d)$/ #specify a replicate except a treatment
      main_study.where(:replicate => $1).where('not treatment_number = ?',$2)
    when /^B(\d+)$/ #specify Biodiversity Plots
      where(:study_id => 2, :treatment_number => $1)
    when /^FERTILITY_GRADIENT$/
      fert_study
    when /^F(\d)$/ #specify N fert
      fert_study.where(:treatment_number => $1)
    when /^F(\d)-(\d)$/
      fert_study.where(:treatment_number => $1..$2)
    when /^CE(\d{1,2})-(\d{1,2})$/
      ce_study.where(:treatment_number => $1..$2)
    when /^IRRIGATED_FERTILITY_GRADIENT$/
      if_study
    when /^IF(\d)$/
      if_study.where(:treatment_number => $1)
    when /^IF(\d)-(\d)$/
      if_study.where(:treatment_number => $1..$2)
    when /^REPT(\d)E(\d)$/
      where(:study_id => 5, :treatment_number => [$1,$2].join)
    when /^GLBRC$/ # specify GLRBC plots
      where(:study_id => 6)
    when /^CES$/ # specify Cellulosic energy study
      where(:study_id => 7)
    else
      by_upper_name(token)
    end

    area.blank? ? [token] : area.all
  end

  def Area.by_upper_name(token)
    where(['upper(name) = ?', token.squeeze.upcase])
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
      overlap += self[id..id].to_s #id..id gives letter in 1.8.7; just id gives char number
      id += 1
    end

    overlap
  end
end
