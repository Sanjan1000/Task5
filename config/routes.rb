Rails.application.routes.draw do
  get 'users', to: 'users#index'
  resources :users, only: [:region, :error_rate,:seed]
  root 'users#index'
end
