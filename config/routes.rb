ActionController::Routing::Routes.draw do |map|
  map.resources :hazards

  # You can have the root of your site routed by hooking up '' 
  # -- just remember to delete public/index.html.
  # map.connect '', :controller => "welcome"
  
  map.resources :areas 
  map.resources :observations, :new => { :add_activity => :post,
  														 					 :add_setup => :post,
  														 					 :add_material => :post,
  														 					 :delete_activity => :post,
  														 					 :delete_setup => :post,
  														 					 :delete_material => :post },
  														 :member => {:add_activity => :put, 
  														             :add_setup => :put,
  														             :add_material => :put,
  														             :delete_activity => :put,
  														             :delete_setup => :put,
  														             :delete_material => :put}
  							
  map.resources :activities
  map.resources :setups
  map.resources :equipment
  map.resources :units
  map.resources :people
  map.resources :reports
  # map.resources :materials
  map.resources :materials, :member => { 	:get_hazards => :get, 
  																				:put_hazards => :put },
  													:new => { :new_hazards => :post }
  
  # map.choose_hazards 'materials/:id/choose_hazards', :controller => 'materials', :action => "choose_hazards", :conditions => { :method => :get }
  
  map.resources :material_transactions
  
  map.open_id_complete 'sessions', :controller => "sessions", :action => "create", :requirements => { :method => :get }
  map.resource :sessions
  
  map.root :controller => 'observations'

  

  map.connect '/', :controller => 'observations'
  
  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  map.connect ':controller/service.wsdl', :action => 'wsdl'

  # Install the default route as the lowest priority.
#  map.connect ':controller/:action/:id'
end
