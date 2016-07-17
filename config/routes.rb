Rails.application.routes.draw do
  get 'people/new'

  root :to => 'pages#main'

  match '/auth/:provider/callback', :to => 'sessions#create', via: [:get, :post]
  match '/auth/failure', :to => 'sessions#failure', via: [:get, :post]

  resources :people
end
