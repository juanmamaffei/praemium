class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception


  protected

  def authenticate_owner!
  	redirect_to root_path unless user_signed_in? && current_user.is_owner? # || current_user.is_admin?)
  end

  def authenticate_admin!
  	redirect_to root_path unless user_signed_in? && current_user.is_admin?
  end

  private
    def company_params
      params.require(:company).permit(:id, :admin)
    end
    def set_company
      @company = Company.find(params[:id])
    end
end
