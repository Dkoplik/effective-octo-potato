Rails.application.routes.draw do
  resources :users do
    member do
      get :confirm
    end
  end

  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "confirmation_success", to: "users#confirmation_success", as: :confirmation_success
  resources :password_resets, only: [ :create, :edit, :update ],  param: :token
  get "password_resets/success", to: "password_resets#success", as: :success_password_reset
  post "delete_account", to: "account#delete_account"

  resources :games, only: [ :create, :update ]
  patch "games/:id/start", to: "games#start"
  get "games/:id", to: "games#show"

  get "/lobbies", to: "lobbies#list_all"

  mount ActionCable.server => "/cable"
end
