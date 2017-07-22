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
    resources :activities
    resources :friends do
      resources :activities, controller: 'friends/activities'
    end
    resources :family_members do
      delete :destroy_spousal_relationship
      delete :destroy_parent_child_relationship
    end
    resources :activities, only: [:index]
  end
end
