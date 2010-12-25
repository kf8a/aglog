# encoding: UTF-8
require 'active_support/builder' unless defined?(Builder)

class Observation < ActiveRecord::Base
  acts_as_state_machine :initial => :published
  
  state  :published
  state  :in_review
  
  event :review do
    transitions :from => :published, :to => :in_review
  end
  
  event :publish do
    transitions :from => :in_review, :to => :published
  end
  
  has_many :activities, :dependent => :destroy
  has_and_belongs_to_many :areas
  has_and_belongs_to_many :observation_types
  belongs_to :person
  
  validates :obs_date,          :presence => true
  validates :observation_types, :presence => true
  validates :person_id,         :presence => true
  validate :no_invalid_areas
    
  def no_invalid_areas
    errors.add(:base, 'invalid areas') if  @error_areas
  end
  
  def in_review
    self.state == 'in_review'
  end
    	
  def in_review=(state)
    return if new_record?
    if state == '0'
      self.publish!
    elsif state == '1'
      self.review!
    end
  end

  def observation_type
    self.observation_types.first.name
  end
  
  def areas_as_text
    if @error_areas then
      return @error_areas
    else
      return Area.unparse(areas)
#      return areas.map(&:name).join(' ')
    end
  end
  
  def areas_as_text=(areas_as_text)
    @error_areas =  nil
    a = Area.parse(areas_as_text)
    if a.class.name ==  'String'  then
      @error_areas = a
    else
      # First delete all the old area asscociations
      self.areas.delete
      # then set new areas
      self.areas  = a
    end
  end
    
  def Observation.to_salus_xml(options = {})
    options[:indent] ||= 2
    xml = options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])
    xml.instruct! unless options[:skip_instruct]

    observations = Observation.find(:all, :include=>[:areas,:activities], :order=>'obs_date desc')
    observations.each do |observation|
      xml.observation do
        xml.date observation.obs_date.to_s
        xml.comment observation.comment
        xml.areas do 
          observation.areas.each do |area|
            xml.area area.name
          end
        end
        xml.observation_types do
          observation.observation_types.each do |type|
            xml.observation_type type.name
          end
        end
        xml.activities do
          observation.activities.each do |activity|
            xml.setups do 
              activity.setups.each do |setup|
                xml.transactions do 
                  setup.material_transactions.each do |transaction|
                    xml.transaction do
                      xml.material transaction.material.name if transaction.material
                      xml.rate transaction.rate
                      xml.n_content transaction.material.n_content if transaction.material
                      xml.unit transaction.unit.name if transaction.unit
                    end
                  end
                end
              end  
            end
          end
        end
      end
    end
  end 
 
  def Observation.to_salus_csv 
    observations = Observation.find(:all,  :include => [:areas,:activities], :order=> 'obs_date desc')
    data = observations.collect do |observation|
      material_names = []
      unit_names = []
      n_contents = []
      rates = []
      observation.activities.each do |activity|
        activity.setups.each do |setup|
          setup.material_transactions.each do |transaction|
            if transaction.material
              material_names << transaction.material.name 
              unit_names << transaction.material.n_content
            
              rates << transaction.rate
              unit_names << transaction.unit.name if transaction.unit
            end
          end
        end
      end
      if RUBY_VERSION > "1.9"
        output = CSV
      else
        output = FasterCSV
      end
      output.generate do |csv|
        observation.areas.each do |area|
          observation.observation_types.each do |type|
            csv << [observation.obs_date.to_s, type.name, area.name, material_names.join(';;'), n_contents.join(';;'), rates.join(';;'),unit_names.join(';;')]
          end
        end
      end
    end
    data.unshift(["#date,type,area,material,n_content,rate,unit\n"])
  end

end
