Aglog::Application.routes.draw do
  resources :person_sessions
  match '/auth/:provider/callback' => 'person_sessions#create'
  match '/auth/failure' => 'person_sessions#new'
  match '/logout' => 'person_sessions#destroy'

  resources :hazards

  post '/areas/:id/move_to/:parent_id' => 'areas#move_to'
  post '/areas/:id/move_before/:parent_id' => 'areas#move_before'
  resources :areas do
    collection do
      get :check_parsing
    end
  end
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
