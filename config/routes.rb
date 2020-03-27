require 'sidekiq/web'
Sidekiq::Web.app_url = '/'

Rails.application.routes.draw do

  # Authenticated routes
  mount Sidekiq::Web => '/sidekiq'

  devise_for :users, skip: :registrations, path: 'users', path_names: {
      sign_in: 'login',
      sign_out: 'logout',
      password: 'password',
      confirmation: 'verification',
      unlock: 'unblock'
  },controllers: {
      sessions: 'users/sessions',
      confirmations: 'users/confirmations',
      passwords: 'users/passwords',
      unlocks: 'users/unlocks'
  }

  devise_scope :user do
    resource :registration,
             only: [:new, :create, :edit, :update],
             path: 'users',
             path_names: { new: 'sign_up' },
             controller: 'users/registrations',
             as: :user_registration do
      get :cancel
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :v1 do

      devise_scope :user do
        post 'signin', to: 'users/sessions#create'
        post '/', to: 'users/registrations#create'
        post 'password', to: 'users/passwords#create'
      end

      resources :callbacks, except: %i[new create edit update destroy] do
        collection do
          post :mobile_login
          post :mobile_sign_up
        end
      end

      resources :users do
        post :register_notification_token, on: :collection
        member do
          get :info
        end
      end
    end
  end
end
