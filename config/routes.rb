Myflix::Application.routes.draw do

  root to: 'pages#front'
  get 'home', to: 'videos#index'

  get 'confirm_password_reset', to: 'pages#confirm_password_reset'
  get 'invalid_token', to: 'pages#invalid_token'
  
  namespace :admin do
    resources :videos, only: [:new, :create]
  end

	resources :videos, only: [:show] do
		collection do
			post :search, to: "videos#search"
		end
    resources :reviews, only: [:create]
	end
  get 'my_queue', to: 'queue_items#index'
  resources :queue_items, only: [:create, :update, :destroy]
  post 'update_queue', to: 'queue_items#update_queue'
  get 'people', to: 'relationships#index'
  resources :relationships, only: [:create, :destroy]
  resources :payments, only: [:new, :create]

  get 'ui(/:action)', controller: 'ui'
  get 'register', to: 'users#new'
  get 'register/:token', to: "users#new_with_invitation_token", as: 'register_with_token'
  get 'sign_in', to: 'sessions#new'
  get 'sign_out', to: 'sessions#destroy'
  resources :users, only: [:create, :show]
  resources :sessions, only: [:create]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :invites, only: [:new, :create]
end
