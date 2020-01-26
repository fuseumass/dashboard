Rails.application.routes.draw do

  resources :mentorship_notifications
  get 'slackintegration/index'
  post 'slackintegration/index'

  resources :prizes
  # Our Root URL Links to the index page (duh)
  root 'pages#index'

  # Authentication Routes Start

    # Make our log in and sign up routes pretty
    devise_for :users, skip: [:sessions, :registration]
    as :user do
      get 'login', to: 'devise/sessions#new', as: :new_user_session
      post 'login', to: 'devise/sessions#create', as: :user_session
      get 'users/edit' => 'devise/registrations#edit', :as => :edit_user_registration
      delete 'logout', to: 'devise/sessions#destroy', as: :destroy_user_session
      get 'signup', to: 'devise/registrations#new', as: :new_user_registration
      post 'signup', to: 'devise/registrations#create', as: :user_registration
      get 'change_pass', to: 'users#go_to_forgot'
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

  resources :custom_rsvps, except: [:destroy] do

  end





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
    resources :events do
      post 'add_user' => 'events#add_user'
      post 'remove_user' => 'events#remove_user'
      post 'check_in_to_event' => 'events#check_in'
    end
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
    post 'unrsvp' => 'pages#unrsvp'
    # Allow users to rsvp for the event
    get 'unrsvp' => 'pages#index'
    # Allow adding permissions to users
    post 'add_permissions' => 'pages#add_permissions'

    # Redirect to home page if accessed using get request
    get 'add_permissions' => 'pages#index'

    # Allow removing permissions from users
    post 'remove_permissions' => 'pages#remove_permissions'

    # Redirect to home page if accessed using get request
    get 'remove_permissions' => 'pages#index'

    # Make our URLs prettier
    get 'index' => 'pages#index'
    get 'admin' => 'pages#admin'

    get 'check_in' => 'pages#check_in'

  # Pages Routes End

    resources :projects do
      get 'team' => 'projects#team', :as => :team
      post 'add_team_member' => 'projects#add_team_member', :as => :add_team_member
      post 'remove_team_member' => 'projects#remove_team_member', :as => :remove_team_member
      collection do
        get 'search'
        get 'public'
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
        post 'slack_message_all_checked_out' => 'hardware_items#slack_message_all_checked_out'
        post 'slack_message_individual_checkout' => 'hardware_items#slack_message_individual_checkout'
        post 'slack_message_individual_item' => 'hardware_items#slack_message_individual_item'
      end
    end

    # Allow autocomplete on user email for all checked out items
    resources :hardware_items, only: [:all_checked_out] do
      get :autocomplete_user_email, :on => :collection
    end

  # Hardware Routes End

  # Email Routes Begin
    resources :emails do
      get 'send' => 'emails#send_email'
    end
  # Email Routes End

  # Routes for Live Judging Begins

  resources :judging do
    resources :judgement
    post 'assign_score'
    get :autocomplete_user_email, :on => :collection
    collection do
      get 'search', :as => :search
      get 'assign'
      get 'results'
    end
  end
  post 'judging/assign_judge' => 'judging#add_judge_assignment', :as => :judging_assign
  post 'judging/unassign_judge' => 'judging#remove_judge_assignment', :as => :judging_unassign




  # Live Judging Routes End

  # Feature Flag Routes Start
   resources :feature_flags, except: [:create, :destroy, :edit, :show] do
     collection do
       post 'enable'
       post 'disable'
     end
   end
  # Feature Flag Routes End


end
