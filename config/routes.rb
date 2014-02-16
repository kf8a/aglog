Aglog::Application.routes.draw do
  devise_for :users

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
  resources :materials

#  match '/' => 'observations#index'
  root :to => "observations#index"
end
