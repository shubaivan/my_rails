Rails.application.routes.draw do
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
  resources :tasks, except: [:index, :show] do
    patch '/', action: :update_all, on: :collection
    get ':type', action: :index,
                 on: :collection,
                 as: :filtered,
                 constraints: { type: /open|done/ }
  end
end
