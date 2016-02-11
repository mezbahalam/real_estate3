Rails.application.routes.draw do


  get "home/index"
  resources :search_suggestions
  root to: "activities#index"
  resources :comments, :only => [:create, :destroy]
  resources :activities
  devise_for :users, :controllers => { registrations: 'users/registrations' }
  resources :users do
    resources :follows, :only => [:create, :destroy]
  end
  resources :lists do
    member do
      put 'add_property'
    end
    # collection do
    #   get 'search'
    # end
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
