Rails.application.routes.draw do
  resources :users do
    member do
      get :confirm
    end
  end

  resources :games

  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "confirmation_success", to: "users#confirmation_success", as: :confirmation_success

  mount ActionCable.server => "/cable"
end
