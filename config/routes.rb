Rails.application.routes.draw do
  
  
  resources :profiles, as: :users, only: [:show, :update]
  
  #devise_for :users, controllers: {registrations: "registrations"}
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

  resources :companies do
  	resources :cards do
      resources :transactions
    end
    #Entorno de trabajo
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

  #Rutas dinámicas para nombres de usuario de las compañías
  #datos = Company.all
  
  #datos.each do |c|
    #A menos que el alias esté vacío...
  #  unless c.alias == nil
  #    get c.alias, to: 'companies#show', :id => c.id    
  #  end
  #end
  

end
