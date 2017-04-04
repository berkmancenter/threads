# frozen_string_literal: true
Rails.application.routes.draw do
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

  resources :rooms
  resources :messages, only: %i(create destroy)

  root to: 'rooms#index'

  mount ActionCable.server => '/cable'
end
