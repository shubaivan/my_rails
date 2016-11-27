Rails.application.routes.draw do
  get 'lists/new'
  get 'lists/shared',  to: 'lists#shared'
  get 'lists/index',   to: 'lists#index'
  post 'lists/edit',   to: 'lists#edit'

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
end
