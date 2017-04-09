Rails.application.routes.draw do
  devise_for :users, controllers: { invitations: "invitations"}
  root 'friends#index'
end
