class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :authenticate_user!
  before_action :detect_device_format
  before_action :set_layout_variables
  before_action :prepare_exception_notifier
  before_action :configure_permitted_parameters, if: :devise_controller?

private

  def detect_device_format
    case request.user_agent
    when /iPhone/i, /Android/i && /mobile/i, /Windows Phone/i
      request.variant = :phone
    else
      request.variant = :desktop
    end
  end

  def set_layout_variables
    @sitename ||= "CrystalData"
    @sitename.concat(" v0.7 ")
  end

  def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      current_user: current_user
    }
  end

protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end

end
