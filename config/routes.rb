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

  namespace :admin do
  	resources :users
    resources :friends do
      resources :asylum_application_drafts
    end
    resources :family_members do
      delete :destroy_spousal_relationship
      delete :destroy_parent_child_relationship
    end
  end
end
