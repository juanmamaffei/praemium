Rails.application.routes.draw do
  
  resources :profiles, as: :users, only: [:show, :update]
  
  devise_for :users, controllers: {registrations: "registrations"}
  

  resources :companies do
  	resources :cards do
      resources :transactions
    end
    get 'panel', to: 'cards#scan'
    post 'panel', to: 'cards#scan'

  end

  #Ruta para asignar usuario a tarjeta existente
  post 'asignar', to: 'cards#asignuser'
  

  #Mostrar INDEX si está logueado
  authenticated :user do
  	root 'main#index'
  end
  
  #Mostrar página de aterrizaje si no está logueado
  unauthenticated :user do
  	devise_scope :user do
  		root 'main#landing'
  	end
  end


end
