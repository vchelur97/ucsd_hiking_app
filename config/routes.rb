Rails.application.routes.draw do
  resources :hikes
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  resource :user, except: %i[new create] do
    resource :waiver, only: %i[new create]
    resource :session, only: %i[new create update destroy]
    resources :cars, except: %i[index]
  end
  resolve('User') { [:user] }
  get 'auth/google_oauth2/callback', to: 'sessions#create'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "hikes#index"
end
