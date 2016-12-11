# frozen_string_literal: true
Rails.application.routes.draw do
  devise_for :users, skip: %i(sessions)

  devise_scope :user do
    get    'login'  => 'devise/sessions#new', as: :new_user_session
    post   'login'  => 'devise/sessions#create', as: :user_session
    delete 'logout' => 'devise/sessions#destroy', as: :destroy_user_session
  end

  resources :rooms

  root to: 'rooms#index'
end
