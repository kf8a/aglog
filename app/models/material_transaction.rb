class MaterialTransaction < ActiveRecord::Base
  belongs_to :material
  belongs_to :setup
  belongs_to :unit
  

  validates_presence_of :material_id
  validates_associated :material
  
  # find fertilizers  on the main site
  def MaterialTransaction.find_fertilizations(order='obs_date desc', study_id =1)
    MaterialTransaction.find_material_type(3,order,study_id)
  end
  
  def MaterialTransaction.find_material_types(material_type_id = 1, order='obs_date desc', study_id =1)
    areas = Area.find(:all, :conditions => ['study_id=?', study_id])
    #    @areas = Area.find(:all, :conditions => ['study_id = 1'])
    MaterialTransaction.find(:all, 
    :conditions => ['materials.material_type_id = ? and area_id in (?)', material_type_id, areas], 
    :order => order,
    :joins => 'join materials on materials.id  = material_transactions.material_id join setups on setups.id = material_transactions.setup_id join activities on setups.activity_id = activities.id  join observations on activities.observation_id = observations.id join areas_observations on areas_observations.observation_id = observations.id join areas on areas_observations.area_id = areas.id join observation_types_observations on observation_types_observations.observation_id  =  observations.id')    
  end
  
  def remove_commas
    self.rate = rate.gsub(/,/,'') if attribute_present?('rate')
  end
  
end
