Rails.application.routes.draw do
  resources :components
  resources :orders

  get "up" => "rails/health#show", as: :rails_health_check
end
