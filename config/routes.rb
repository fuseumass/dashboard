Rails.application.routes.draw do

  resources :prizes
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
    resources :mentorship_requests, constraints: { id: /\d+/ } do
      collection do
        put 'mark_as_resolved'
        put 'mark_as_denied'
        get 'message_on_slack'
        get 'search'
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

    # Allow users to rsvp for the event
    get 'rsvp' => 'pages#rsvp'

    get 'join_slack' => 'pages#join_slack'

    # Allow users to rsvp for the event
    get 'unrsvp' => 'pages#unrsvp'

    # Allow adding permissions to users
    get 'add_permissions' => 'pages#add_permissions'

    # Allow removing permissions from users
    get 'remove_permissions' => 'pages#remove_permissions'

    # Make our URLs prettier
    get 'index' => 'pages#index'
    get 'admin' => 'pages#admin'

    get 'check_in' => 'pages#check_in'

  # Pages Routes End

    resources :projects do
      collection do
        get 'search'
      end
    end

    get 'projects/new/project_submit_info' => 'projects#project_submit_info', :as => :project_submit_info

  # Hardware Routes Start

    # Allow autocomplete on hardware checkout page
    resources :hardware_checkouts, only: [:create, :destroy] do
      get :autocomplete_user_email, :on => :collection
    end

    # Allow us to perform search on the hardware page
    resources :hardware_items do
      collection do
        get 'search'
        get 'all_checked_out' => 'hardware_items#all_checked_out'
      end
    end

  # Hardware Routes End

  # Email Routes Begin
    resources :emails do
      get 'send' => 'emails#send_email'
    end
  # Email Routes End

  # Feature Flag Routes Start
   resources :feature_flags, except: [:create, :destroy, :edit, :show] do
     collection do
       post 'enable'
       post 'disable'
     end
   end
  # Feature Flag Routes End

  # Judging Routes Begin
  get 'judgings' => 'judging#index'
  post 'generateforms' => 'judging#generateforms'
  get "#{Rails.root}/public/judging/judging.pdf", :to => redirect('/judging/judging.pdf')
  # Judging Routes End
end
