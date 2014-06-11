Rails.application.routes.draw do
  root 'pages#index'

  get "/styles" => "pages#styles"

  namespace :api do
    resources :people
  end
end
