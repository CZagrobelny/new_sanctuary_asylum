Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: "invitations"}
  
  root to: 'devise/sessions#new'
  get 'admin', to: 'admin/dashboard#index'
  get 'dashboard', to: 'user/dashboard#index'

  resources :users, only: [:edit, :update]
  namespace :admin do
  	resources :users
    resources :friends
  end
end
