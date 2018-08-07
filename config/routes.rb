Rails.application.routes.draw do

  # Our Root URL Links to the index page (duh)
  root 'pages#index'

  # Authentication Routes Start

    # Make our log in and sign up routes pretty
    devise_for :users, skip: [:sessions, :registration]
    as :user do
      get 'login', to: 'devise/sessions#new', as: :new_user_session
      post 'login', to: 'devise/sessions#create', as: :user_session
      delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
      get 'signup', to: 'devise/registrations#new', as: :new_user_registration
      post 'signup', to: 'devise/registrations#create', as: :user_registration
    end

  #Authentication Routes End


  # Event Application Routes Start

    # Make our application link more user friendly
    get 'apply' => 'event_applications#new'

    #Allow us to update the status of an application
    resources :event_applications, except: [:destroy] do
      collection do
        post 'status_updated'
        post 'flag_application'
        post 'unflag_application'
        post 'app_rsvp'
        get 'search'

        get :rsvp
        get :unrsvp
        get :autocomplete_university_name
        get :autocomplete_major_name
      end
    end

  # Event Application Routes End



  # Mentorship Request Routes Start

    # Create all routes but index
    resources :mentorship_requests do
      collection do
        post 'mark_as_resolved'
        post 'mark_as_denied'
      end
    end



  # Mentorship Request Routes End



  # Events Routes Start

    #Create all routes for Events
    resources :events

  # Events Routes End


  # Pages Routes Start

    # Allow autocomplete on admin page
    resources :pages do
      get :autocomplete_user_email, :on => :collection
    end

    # Allow adding permissions to users
    get 'add_permissions' => 'pages#add_permissions'

    # Allow removing permissions from users
    get 'remove_permissions' => 'pages#remove_permissions'

    # Make our URLs prettier
    get 'index' => 'pages#index'
    get 'admin' => 'pages#admin'

    get 'check_in' => 'pages#check_in'

  # Pages Routes End


  # Hardware Routes Start

    # Allow autocomplete on hardware checkout page
    resources :hardware_checkouts, only: [:create, :destroy] do
      get :autocomplete_user_email, :on => :collection
    end

    # Allow us to perform search on the hardware page
    resources :hardware_items do
      collection do
        get 'search'
      end
    end

  # Hardware Routes End

  # Email Routes Begin
    resources :emails do
      get 'send' => 'emails#send_email'
    end
  # Email Routes End

  # Feature Flag Routes Start
    resources :feature_flags, except: [:create, :destroy, :edit, :show]
  # Feature Flag Routes End
end
