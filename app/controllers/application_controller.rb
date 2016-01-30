class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  before_action :configure_permitted_parameters, if: :devise_controller?

  # def current_user
  #   @current_user ||= User.find(session[:user_id]) if session[:user_id]
  # end
  #
  # helper_method :current_user
  # hide_action :current_user

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up)  { |u| u.permit(  :email,:password, :password_confirmation ,  :user_name, :first_name, :last_name, :location, :bio ) }
    devise_parameter_sanitizer.for(:accept_invitation).concat([:first_name, :last_name, :user_name])
  end

  include PublicActivity::StoreController

  private

    def after_invite_path_for(resource)
      list_path(@list)
    end

end
