Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: "invitations"}
  root 'dashboard#index'
  resources :users, only: [:edit, :index, :update, :destroy]
  namespace :admin do
    resources :friends
  end
end
