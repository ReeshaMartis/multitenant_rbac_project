Rails.application.routes.draw do
  
  get "up" => "rails/health#show", as: :rails_health_check

  post '/signup', to: 'users#create'
  post '/login',  to: 'users#login'

  resources :projects do
    resources :tasks, only: [:index, :show, :create, :update, :destroy] do
      resources :discussion_threads, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
