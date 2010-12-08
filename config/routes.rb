Aglog::Application.routes.draw do
  resources :authentications

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
  resources :person_sessions
  resource :user_session
  match 'sessions' => 'sessions#create'#, :as => :open_id_complete, :constraints => { :method => get }
  match '/' => 'observations#index'

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  match ':controller/service.wsdl' => '#wsdl'
end