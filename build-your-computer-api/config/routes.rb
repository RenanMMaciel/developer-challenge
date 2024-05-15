Rails.application.routes.draw do
  resources :components

  get "up" => "rails/health#show", as: :rails_health_check
end
