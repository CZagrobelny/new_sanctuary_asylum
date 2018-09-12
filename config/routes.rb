Rails.application.routes.draw do

  devise_for :users, skip: :invitations
  devise_scope :user do
    authenticated do
      root to: 'dashboard#index', as: :root
    end

    unauthenticated do
      root to: 'devise/sessions#new', as: :unauthenticated_root
    end
  end

  get 'pledge', to: 'home#pledge'

  resources :communities, param: :slug, only: [] do
    devise_for :users, only: [:invitations], controllers: { invitations: "invitations" }
    get 'admin', to: 'admin/friends#index'
    get 'dashboard', to: 'dashboard#index'

    resources :users, only: [:edit, :update]
    resources :friends, only: [:index, :show, :update] do
      resources :drafts do
        member do
          get :submit_for_review
          get :approve
        end
        resources :reviews, only: [:new, :show, :create, :edit, :update]
      end
    end
    resources :accompaniments
    resources :activities, only: [:index]

    namespace :admin do
    	resources :users
      resources :activities, except: [:destroy] do
        collection do
          get :accompaniments
        end
        member do
          post :confirm
        end
      end
      resources :friends do
        resources :activities, controller: 'friends/activities' do
          member do
            post :confirm
          end
        end
        resources :detentions, controller: 'friends/detentions'
        resources :family_members
        resources :family_relationships
      end

      resources :judges, except: [:show, :destroy]
      resources :locations, except: [:show, :destroy]
      resources :sanctuaries, except: [:show, :destroy]
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
  end

  namespace :regional_admin do
    devise_for :users, only: [:invitations], controllers: { invitations: "invitations" }
    resources :regions, only: [] do
      resources :communities, only: [:index, :new, :create, :edit, :update]
      resources :friends, only: [:index, :show, :update] do
        resources :applications, only: [] do
          get :close
        end
      end
    end
    resources :remote_lawyers, only: [:index, :destroy, :edit, :update]
  end

  namespace :remote_clinic do
    resources :friends, only: [:index, :show]
  end

	match '/404', to: 'errors#not_found', via: :all
	match '/500', to: 'errors#internal_server_error', via: :all
end
