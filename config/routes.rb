Rails.application.routes.draw do
  get 'lists/new'
  get 'lists/index',   to: 'lists#index'

  get 'static_pages/contact'
  get 'static_pages/home'
  get    '/signup',   to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  post '/signup',  to: 'users#create'
  resources :users
  resources :sessions

  root to: 'tasks#index'

  # get  'signup' => 'users#new'
  # get  'login' => 'sessions#new'
  # post 'login' => 'sessions#create'
  # get  'logout' => 'sessions#destroy'

  resources :lists do
    resources :tasks, except: [:show] do
      patch '/', action: :update_all, on: :collection
      get ':type', action: :index,
                   on: :collection,
                   as: :filtered,
                   constraints: { type: /open|done/ }
      collection do
        get 'remove_completed'
        patch 'update_all'
      end
    end
  end

  # resources :users
  # resources :sessions
end
