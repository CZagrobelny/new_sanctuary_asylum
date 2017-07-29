Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: "invitations"}
  
  authenticated :user do
    root :to => 'dashboard#index', as: :authenticated_root
  end
  root to: 'home#index'
  get 'admin', to: 'admin/dashboard#index'
  get 'dashboard', to: 'dashboard#index'

  resources :users, only: [:edit, :update]
  resources :friends, only: [:index, :show, :update] do
    resources :asylum_application_drafts
  end
  resources :accompaniements
  resources :activities, only: [:index]

  namespace :admin do
  	resources :users
    resources :activities, except: [:destroy] do
      collection do
        get :last_month
      end
    end
    resources :friends do
      resources :activities, controller: 'friends/activities'
      resources :family_members
    end

    resources :judges, except: [:show]
    resources :locations, except: [:show]
  end
end
