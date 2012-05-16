Aglog::Application.routes.draw do
  devise_for :users

  resources :hazards

  post '/areas/:id/move_to/:parent_id' => 'areas#move_to'
  post '/areas/:id/move_before/:parent_id' => 'areas#move_before'
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

#  match '/' => 'observations#index'
  root :to => "observations#index"

  # Allow downloading Web Service WSDL as a file with an extension
  # instead of a file named 'wsdl'
  match ':controller/service.wsdl' => '#wsdl'
end
