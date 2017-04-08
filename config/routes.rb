Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
end
