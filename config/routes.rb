Rails.application.routes.draw do
  devise_for :users, skip: :invitations,
    controllers: { password_expired: 'devise_overrides/password_expired',
    sessions: 'devise_overrides/sessions' }
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

    resources :users, only: [:edit, :update] do
      collection do
        get :select2_options
      end
    end
    resources :friends, only: [:index, :show, :update] do
      resources :drafts do
        member do
          patch :submit_for_review
          patch :approve
        end
        resources :reviews, except: [:index]
      end
    end
    resources :accompaniments, only: [:create, :update]
    resources :activities, only: [:index] do
      collection do
        get :accompaniment_program_paused
      end
    end

    namespace :admin do
        resources :users, except: [:new, :create, :show] do
        member do
          patch :unlock
        end
        collection do
          get :select2_options
        end
      end
      resources :access_time_slots, except: [:show]
      resources :activities, except: [:destroy] do
        collection do
          get :accompaniments
          get :select2_regional_friends
        end
        member do
          patch :confirm
          patch :unconfirm
        end
      end
      resources :friends, except: [:show] do
        collection do
          get :select2_options
        end
        resources :activities, controller: 'friends/activities', except: [:index, :show] do
          member do
          patch :confirm
          patch :unconfirm
          end
        end
        resources :detentions, controller: 'friends/detentions', except: [:index, :show]
        resources :friend_notes, controller: 'friends/friend_notes', except: [:index, :show]

        resources :ankle_monitors, controller: 'friends/ankle_monitors', except: [:index, :show]
        resources :family_relationships, only: [:new, :create, :destroy]
      end

      resources :judges, except: [:show, :destroy] do
        member do
          patch :toggle
        end
      end
      resources :locations, except: [:show, :destroy]
      resources :sanctuaries, except: [:show, :destroy]
      resources :lawyers, except: [:show, :destroy]

      resources :events, except: [:show] do
        member do
          get :attendance
        end
        resources :user_event_attendances, only: [:create, :destroy] do
          collection do
            get :select2_options
          end
        end
        resources :friend_event_attendances, only: [:create, :destroy] do
          collection do
            get :select2_options
          end
        end
      end

      resources :cohorts, except: [:show] do
        collection do
          get :select2_friend_options
        end
        member do
          get :assignment
        end
        resources :friend_cohort_assignments, only: [:create, :update, :destroy]
      end

      resources :stats
    end

    namespace :accompaniment_leader do
      resources :friends, only: [:show] do
        resources :activities, controller: 'friends/activities', only: [:new, :create]
      end
      resources :activities, only: [:index] do
        resources :accompaniment_reports, except: [:index, :show, :destroy]
      end
    end

    namespace :eoir_caller do
      resources :search, only: [:index]
      resources :friends, only: [] do
        resources :friend_notes, controller: 'friends/friend_notes', except: [:index, :show]
        resources :activities, controller: 'friends/activities', except: [:index, :show]
      end
    end
  end

  namespace :regional_admin do
    devise_for :users, only: [:invitations], controllers: { invitations: "invitations" }

    resources :regions, only: [] do
      resources :communities, except: [:show, :destroy]
      resources :friends, only: [:show, :update] do
        resources :applications, only: [] do
          patch :close
        end
      end
      resources :remote_review_actions, only: [:index]
    end
    resources :remote_lawyers, except: [:new, :create, :show]
  end

  namespace :remote_clinic do
    resources :friends, only: [:index, :show]
  end

  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
