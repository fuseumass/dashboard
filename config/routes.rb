Rails.application.routes.draw do
  resources :mentorship_requests, except: [:index]
  resources :hardware_checkouts, only: [:create, :destroy]
  resources :event_applications, except: [:edit, :destory]
  devise_for :users

  root 'pages#index'

  get 'index' => 'pages#index'
  get 'admin' => 'pages#admin'
  get 'add_permissions' => 'pages#add_permissions'

  get 'remove_permissions' => 'pages#remove_permissions'

  get 'apply' => 'event_applications#new'

  resources :hardware_items do
  	collection do
  		get 'search'
  	end
  end

  resources :event_applications do
  	collection do
      post 'status_updated'
    end
  end

end
