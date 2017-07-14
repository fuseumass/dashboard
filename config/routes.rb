Rails.application.routes.draw do
  resources :events
  resources :mentorship_requests, except: [:index]
  resources :event_applications, except: [:edit, :destroy]
  # this creates the route allowing the view to access the data required to autocomplete
  resources :pages do 
    get :autocomplete_user_email, :on => :collection
  end

  resources :hardware_checkouts, only: [:create, :destroy] do
    get :autocomplete_user_email, :on => :collection
  end


  # Make our log in and sign up routes pretty
 devise_for :users, skip: [:sessions, :registration]
  as :user do
    get 'login', to: 'devise/sessions#new', as: :new_user_session
    post 'login', to: 'devise/sessions#create', as: :user_session
    delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session

    get 'signup', to: 'devise/registrations#new', as: :new_user_registration
    post 'signup', to: 'devise/registrations#create', as: :user_registration
  end

  root 'pages#index'
    #get :autocomplete_user_email, :on => :collection

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
