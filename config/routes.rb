Rails.application.routes.draw do
  resources :hardware_items
  resources :event_applications
  devise_for :users

  root 'navigation#index'

  get 'index' => 'navigation#index'
  get 'about' => 'navigation#about'

  get 'apply' => 'event_applications#new'



end
