# frozen_string_literal: true

Rails.application.routes.draw do
  get '/wps', to: 'wps#index'
  devise_for :users

  post '/areas/:id/move_to/:parent_id' => 'areas#move_to'
  post '/areas/:id/move_before/:parent_id' => 'areas#move_before'
  resources :areas
  resources :observations do
    collection { get :related }
  end
  resources :activities, only: %i[create update destroy]
  resources :setups, only: %i[create update destroy]
  resources :material_transactions, only: %i[create update destroy]
  resources :equipment
  resources :units
  resources :people
  resources :reports
  resources :materials
  resources :salus, only: %i[index show]
  resources :observation_types, only: %i[index]

  root to: 'observations#index'
end
