Rails.application.routes.draw do



  root to: "activities#index"
  resources :comments, :only => [:create, :destroy]
  resources :activities
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  resources :users
  resources :lists do
    member do
      post 'add_property'
    end
  end
  resources :properties do
    member do
     post 'add_to_list'
    end
  end
  resources :invites

  match :like, to: 'likes#create', as: :like, via: :post
  match :unlike, to: 'likes#destroy', as: :unlike, via: :post
end
