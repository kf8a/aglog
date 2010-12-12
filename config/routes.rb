Aglog::Application.routes.draw do
  resources :person_sessions
  match '/auth/:provider/callback' => 'person_sessions#create'
  match '/auth/failure' => 'person_sessions#new'
  match '/logout' => 'person_sessions#destroy'

  resources :activities
  resources :hazards
  resources :areas
  resources :observations
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
  match '/' => 'observations#index'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  match ':controller/service.wsdl' => '#wsdl'
end