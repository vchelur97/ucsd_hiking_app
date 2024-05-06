Rails.application.routes.draw do
  resources :hikes do
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

  # get "admin", to: "admin#stats"
  # namespace :admin do
  #   resources :users
  #   resources :hikes
  #   resources :push_notifications
  # end

  get "up" => "rails/health#show", as: :rails_health_check

  root "dashboard#index"
end
