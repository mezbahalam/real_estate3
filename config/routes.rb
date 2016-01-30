Rails.application.routes.draw do



  root to: "lists#index"
  resources :comments, :only => [:create, :destroy]
  resources :activities
  devise_for :users
  resources :users

  resources :lists do
    member do
      post :invite
    end
    resources :properties
  end



end
