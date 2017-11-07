# frozen_string_literal: true

Rails.application.routes.draw do

  devise_for :members, only: :invitations, controllers: { invitations: 'admins/invitations' }
  devise_for :members, only: [:sessions, :passwords, :two_factor_authentications, :two_factor_recoveries], path: :auth, path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    two_factor_authentication: 'two_factor',
    two_factor_recovery: 'two_factor/recovery'
  }

  devise_scope :members do
    get 'auth/sudo' => 'reauthentication#new', as: :new_reauthentication
    post 'auth/sudo' => 'reauthentication#create', as: :reauthentication
  end

  namespace :admins do
    root to: 'dashboard#index'

    post '/coins/:id/load' => 'coins#load', as: :load_coin
    get '/coins/:id/history' => 'coins#history', as: :coin_history

    resources :coins, only: [:index, :edit, :update], path_names: { edit: 'load' } do
      resources :allocations, only: [:new, :create]
    end

    resources :members, only: [:index, :new, :create]
  end

  namespace :settings, module: :members do
    root to: 'settings#index'
    resource :password, only: [:new, :update]

    get 'two_factor_authentication' => 'two_factor#index', as: :two_factor
    get 'two_factor_authentication/resend_code' => 'two_factor#resend_code', as: :resend_two_factor_code
    get 'two_factor_authentication/recovery_codes' => 'recovery_codes#show', as: :two_factor_recovery_codes
    get 'two_factor_authentication/fallback_sms' => 'fallback_sms#new', as: :new_two_factor_fallback_sms

    post 'two_factor_authentication/fallback_sms' => 'fallback_sms#create', as: :two_factor_fallback_sms
    post 'two_factor_authentication/disable' => 'two_factor#destroy', as: :disable_two_factor

    resource :two_factor_authentication, only: [:new, :create, :edit, :update],
             as: :two_factor, controller: :two_factor, path_names: { edit: 'confirm' }
  end

  scope module: :members do
    root to: "dashboard#index"

    resources :coins, only: [:index]
    resources :coins, only: [:show], format: :js

    scope path: :trade do
      root to: 'purchases#index', as: :purchases
      get '/:coin_id' => 'purchases#new', as: :new_purchase
      post '/:coin_id/' => 'purchases#create', as: :purchase
    end

    resources :members, path: '/', only: [:show, :update]
  end
end
