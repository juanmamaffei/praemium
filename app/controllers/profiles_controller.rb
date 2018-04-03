class ProfilesController < ApplicationController
	before_action :authenticate_user!
	before_action :set_user
	before_action :verify_own_user

	def show
		
	end

	def update
		
		if @user.update(user_params)
			redirect_to root_path, notice: 'Perfil actualizado'
		else
			#No se pudo guardar
			redirect_to user_path, notice: 'Epa! Hubo un error...'
		end
	end

	private
		def set_user
			@user = User.find(params[:id])			
		end

		def user_params
			params.require(:user).permit(:email, :name, :last_name, :dni, :birth_date, :bio)
		end

		def verify_own_user
	      unless (@user.id == current_user.id)
	        unless current_user.is_admin?
	           redirect_to root_path
	        end
	      end
	    end
end