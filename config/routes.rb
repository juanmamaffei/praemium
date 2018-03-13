Rails.application.routes.draw do
  
  devise_for :users

  resources :companies do
  	resources :cards
  end
  
  authenticated :user do
  	root 'main#index'
  end
  unauthenticated :user do
  	devise_scope :user do
  		root 'main#landing'
  	end
  end

end
