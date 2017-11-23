Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'

  resources :users, only: [:show, :update]

  resources :questions do
    resources :answers
  end
end
