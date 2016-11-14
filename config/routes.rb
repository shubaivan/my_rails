Rails.application.routes.draw do
  root to: 'tasks#index'
  resources :tasks, except: [:index, :show] do
    patch '/', action: :update_all, on: :collection
    get ':type', action: :index,
                 on: :collection,
                 as: :filtered,
                 constraints: { type: /open|done/ }
  end
end
