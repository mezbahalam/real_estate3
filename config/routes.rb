Rails.application.routes.draw do



  root to: "lists#index"
  resources :comments, :only => [:create, :destroy]
  resources :activities
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  resources :users

  resources :lists do
    resources :properties, except: :show
  end
  resources :properties , only: :show
  resources :invites

  match :like, to: 'likes#create', as: :like, via: :post
  match :unlike, to: 'likes#destroy', as: :unlike, via: :post
end
