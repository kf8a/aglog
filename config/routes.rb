Aglog::Application.routes.draw do
  resources :person_sessions
  match '/auth/:provider/callback' => 'person_sessions#create'
  match '/auth/failure' => 'person_sessions#new'
  match '/logout' => 'person_sessions#destroy'

  resources :activities, :only => [:create, :update, :destroy]
  resources :hazards
  resources :areas
  resources :observations do
    collection do
      get :related
    end
  end
  resources :activities,            :only => [:create, :update, :destroy]
  resources :setups,                :only => [:create, :update, :destroy]
  resources :material_transactions, :only => [:create, :update, :destroy]
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
  
  match '/' => 'observations#index'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  match ':controller/service.wsdl' => '#wsdl'
end