Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: "invitations", sessions: "sessions" }

  devise_scope :user do
    authenticated do
      root :to => 'dashboard#index', as: :root
    end

    unauthenticated do
      root :to => 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  get 'admin', to: 'admin/activities#index'
  get 'dashboard', to: 'dashboard#index'
  get 'pledge', to: 'home#pledge'

  resources :users, only: [:edit, :update]
  resources :friends, only: [:index, :show, :update] do
    resources :asylum_application_drafts
    resources :sijs_application_drafts
  end
  resources :accompaniments
  resources :activities, only: [:index]

  namespace :admin do
  	resources :users
    resources :activities, except: [:destroy] do
      collection do
        get :last_month
        get :accompaniments
        get :last_month_accompaniments
      end
    end
    resources :friends do
      resources :activities, controller: 'friends/activities'
      resources :detentions, controller: 'friends/detentions'
      resources :family_members
    end

    resources :judges, except: [:show, :destroy]
    resources :locations, except: [:show, :destroy]
    resources :lawyers, except: [:show, :destroy]

    resources :events do
      member do
        get :attendance
      end
      resources :friend_event_attendances, only: [:create, :destroy]
      resources :user_event_attendances, only: [:create, :destroy]
      resources :friend_event_attendances, only: [:create, :destroy]
    end

    get 'reports/new', to: 'reports#new'
    post 'reports/create', to: 'reports#create'
  end

  namespace :accompaniment_leader do
    resources :activities, only: [:index] do
      resources :accompaniment_reports, only: [:edit, :new, :create, :update]
    end
  end

	match "/404", :to => "errors#not_found", :via => :all
	match "/500", :to => "errors#internal_server_error", :via => :all
end
