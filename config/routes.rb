# frozen_string_literal: true
Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }, path: '', path_names: {
    'sign_in': 'signin',
    'sign_out': 'signout'
  }, skip: %i(registrations omniauth_callbacks)

  devise_scope :user do
    resource :registrations, only: %i(new create), path: '', path_names: { 'new': 'signup' },
                             controller: 'users/registrations', as: :user_registration
  end

  resources :rooms do
    resources :messages, only: %i(create destroy) do
      collection { get 'old/:first_message_id' => 'messages#old', constraints: { first_message_id: /\d+/ } }
    end
    collection do
      get :simple
    end
    member do
      post :set_delayed_lock
      post :mute_user
      post :unmute_user
      put :lock
      put :unlock
      put :cancel_delayed_lock
      get :messages
    end
  end

  resources :instances do
    member do
      get :new_room, to: 'rooms#new'
      post :set_moderators
      put :close
      put :open
      put :private
      put :unprivate
      get :export
    end
  end

  root to: 'instances#index'

  mount ActionCable.server => '/cable'
end
