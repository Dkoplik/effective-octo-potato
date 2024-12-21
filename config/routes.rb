Rails.application.routes.draw do
  resources :users do
    member do
      get :confirm
    end
  end

  resources :games

  mount ActionCable.server => "/cable"
end
