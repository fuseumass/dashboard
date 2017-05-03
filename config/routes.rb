Rails.application.routes.draw do
  resources :hardware_checkouts, only: [:create, :destroy]
  resources :event_applications
  devise_for :users

  root 'navigation#index'

  get 'index' => 'navigation#index'
  get 'admin' => 'navigation#admin'
  get 'add_permissions' => 'navigation#add_permissions'

  get 'remove_permissions' => 'navigation#remove_permissions'

  get 'apply' => 'event_applications#new'

  resources :hardware_items do
  	collection do
  		get 'search'
  	end
  end





end
