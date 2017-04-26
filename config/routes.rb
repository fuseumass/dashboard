Rails.application.routes.draw do
  resources :event_applications
  devise_for :users

  root 'navigation#index'

  get 'index' => 'navigation#index'
  get 'about' => 'navigation#about'

  get 'apply' => 'event_applications#new'

  resources :hardware_items do
  	collection do
  		get 'search'
  	end
  end



end
