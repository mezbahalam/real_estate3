class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  before_action :configure_permitted_parameters, if: :devise_controller?


  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) <<  [:email,:password, :password_confirmation ,  :user_name, :first_name, :last_name, :location, :bio, :invite_token]
    devise_parameter_sanitizer.for(:accept_invitation).concat([:first_name, :last_name, :user_name])
  end

  include PublicActivity::StoreController

  private

    def after_invite_path_for(resource)
      list_path(@list)
    end

end
