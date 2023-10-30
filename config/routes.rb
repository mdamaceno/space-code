Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :pilots, only: [:create]
  resources :contracts, only: [:index, :create] do
    member do
      post :accept, to: "contracts#accept", as: :accept
    end
  end
  resources :travels, only: [:create]
  resource :fuel, only: [:create]

  scope :reports do
    get 'total-weight-by-each-planet', to: "reports#total_weight_by_each_planet", as: :reports_total_weight_by_each_planet
    get 'percentage-resource-by-each-pilot', to: "reports#percentage_resource_by_each_pilot", as: :reports_percentage_resource_by_each_pilot
  end
end
