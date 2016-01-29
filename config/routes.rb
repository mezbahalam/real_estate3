Rails.application.routes.draw do


  root to: "lists#index"

  devise_for :users

  resources :lists do
    member do
      post :invite
    end
    resources :properties
  end

end
