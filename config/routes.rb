Rails.application.routes.draw do
  resources :event_applications
  devise_for :users

  root 'navigation#index'

  get 'index' => 'navigation#index'
  get 'about' => 'navigation#about'



end
