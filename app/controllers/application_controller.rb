class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception



  protected

  def after_sign_in_path_for(resource)
    if params[:redirect_to].present?
      store_location_for(resource, params[:redirect_to])
    elsif request.referer == new_session_url(:user)
      super
    else
      stored_location_for(resource) || request.referer || root_path
    end
      
  end

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
