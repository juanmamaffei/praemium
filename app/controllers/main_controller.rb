class MainController < ApplicationController
	#before_action :authenticate_user!, except(:show)
	layout false

	def index
		set_cards
		set_companies
		verify_profile

	    #Requires para generar códigos de barra
	    require 'barby'
	    require 'barby/barcode/ean_13'
	    require 'barby/outputter/png_outputter'
	end

	def landing
	end
	
	private
		def set_cards
			@cards = Card.where(user: current_user).order(created_at: :desc)
			@company_names = Company.select("id", "name", "cover_file_name")
		end

		def set_companies
			@companies = Company.where(admin: current_user).order(created_at: :desc)
		end

		def verify_profile
			#Verifica la existencia de los distintos elementos del perfil. Si no existe alguno, redirecciona a la edición del mismo.
			if current_user.name == nil || current_user.name == ""
				redirect_to user_path(current_user.id), notice: "Completá tu nombre", incomplete:true
			else
				if current_user.last_name == nil || current_user.last_name == ""
					redirect_to user_path(current_user.id), notice: "Completá tu apellido", incomplete:true
				else
					if current_user.dni == nil || current_user.dni == ""
						redirect_to user_path(current_user.id), notice: "Completá tu DNI", incomplete:true
					else
						if current_user.birth_date == nil
							redirect_to user_path(current_user.id), notice: "Completá tu fecha de nacimiento", incomplete:true
						end
					end
				end
			end

		end
end
