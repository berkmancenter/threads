Rails.application.routes.draw do
  devise_for :users, skip: %i(sessions)

  devise_scope :user do
    get    'login'  => 'devise/sessions#new'
    post   'login'  => 'devise/sessions#create', as: :session
    delete 'logout' => 'devise/sessions#destroy'
  end

  resources :rooms

  root to: 'rooms#index'
end
