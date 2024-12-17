Rails.application.routes.draw do
  resources :users do
    get :stats, on: :member
  end

  resources :games

  mount ActionCable.server => "/cable"
end