Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
  get "/initialize_chatgpt" => "home#initialize_chatgpt", as: "initialize_chatgpt"
  get "/chatgpt_response" => "home#chatgpt_response", as: "chatgpt_response"

  resources :search_jobs, only: [:index, :show]
  resources :user_jobs do
    get :save_job, on: :collection
  end
end
