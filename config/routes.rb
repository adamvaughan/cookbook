Rails.application.routes.draw do
  resources :recipes

  resources :plans do
    resource :list, only: [:show, :edit, :update, :destroy]
  end

  get 'views/partials/*name', to: 'partials#show', as: 'partial'

  root to: 'partials#index'

  get '*path', to: 'partials#index'
end
