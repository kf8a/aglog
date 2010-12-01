Aglog::Application.routes.draw do
  resources :hazards
  resources :areas
  resources :observations do
    member do
      put :add_material
      put :delete_activity
      put :delete_setup
      put :delete_material
      put :add_activity
      put :add_setup
    end
    collection do
      post :add_material
      post :delete_activity
      post :delete_setup
      post :delete_material
      post :add_activity
      post :add_setup
    end
  end

  resources :activities
  resources :setups
  resources :equipment
  resources :units
  resources :people
  resources :reports
  resources :materials do
    member do
      put :put_hazards
      get :get_hazards
    end
    collection do
      post :new_hazards
    end
  end

  resources :material_transactions
  resources :person_sessions
  resource :user_session
  match 'sessions' => 'sessions#create'#, :as => :open_id_complete, :constraints => { :method => get }
  match '/' => 'observations#index'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  match ':controller/service.wsdl' => '#wsdl'
end