Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"

  resources :search_jobs, only: [:index]
  resources :user_jobs do
    get :save_job, on: :collection
  end
end
