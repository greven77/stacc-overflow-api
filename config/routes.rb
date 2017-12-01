Rails.application.routes.draw do
  post 'signin', to: 'authentication#authenticate'
  post 'signup', to: 'users#create'

  resources :users, only: [:show, :update]

  resources :tags, only: [:index] do
    collection do
      get :search
    end
  end

  resources :questions do
    collection do
      get :tag_cloud
      get :search
      get '/tagged/:tagged_with', to: "questions#tagged"
    end

    member do
      put :vote
      get :thread
    end

    resources :answers do
      member do
        put :vote
      end
    end
  end
end
