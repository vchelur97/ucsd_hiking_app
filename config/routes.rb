Rails.application.routes.draw do
  resources :hikes do
    member do
      match 'subscribe', to: 'hikes#subscribe', via: %i[get post delete]
    end
    resources :hike_cars, shallow: true, except: %i[index] do
      resources :hike_participants, shallow: true, except: %i[index]
    end
  end
  get 'hike_details' => 'hikes#hike_details', as: :get_hike_details

  resource :user, except: %i[new create] do
    resource :waiver, only: %i[new create show]
    resource :session, only: %i[new create update destroy]
    resources :cars, except: %i[index]
  end
  resolve('User') { [:user] }
  get 'auth/google_oauth2/callback', to: 'sessions#create'

  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"
end
