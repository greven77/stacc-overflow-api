Rails.application.routes.draw do
  post 'auth/login', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'

  resources :users, only: [:show, :update]

  resources :questions do
    collection do
      get :tag_cloud
    end

    member do
      put :vote
    end

    resources :answers do
      member do
        put :vote
      end
    end
  end
end
