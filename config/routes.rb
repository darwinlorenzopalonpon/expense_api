Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      resources :users, only: [ :index ]
      resources :expenses, only: [ :index, :show, :create, :update, :destroy ] do
        member do
          post :submit
          post :approve
          post :reject
        end
      end
    end
  end

  get "*path",
      to: "application#fallback_index_html",
      constraints: ->(request) { !request.xhr? && request.format.html? }

  root "application#fallback_index_html"
end
