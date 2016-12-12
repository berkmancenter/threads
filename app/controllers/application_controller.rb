# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  private

  def configure_permitted_parameters 
    devise_parameter_sanitizer.permit(:sign_up, keys: %i(username))
  end
end
