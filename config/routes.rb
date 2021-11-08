Rails.application.routes.draw do
  post '/users', to: 'users#create'
  post '/users/accounts', to: 'accounts#create'
  post '/users/:user_id/accounts/:currency', to: 'accounts#deposit'
end
