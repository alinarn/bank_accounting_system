Rails.application.routes.draw do
  post '/users', to: 'users#create'
  post '/users/accounts', to: 'accounts#create'
end
