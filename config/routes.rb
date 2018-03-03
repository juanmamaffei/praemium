Rails.application.routes.draw do
  resources :transactions
  devise_for :clients
  resources :companies do
  	resources :clients
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'main#index'

end
