class ApplicationController < ActionController::Base
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :authenticate_user!
  #before_action :detect_device_format
  before_action :set_layout_variables
  before_action :prepare_exception_notifier
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(user)
    if user.favorite_table.present?
      table_path(user.favorite_table)
    else
      tables_path
    end
  end

private

  def set_layout_variables
    @sitename ||= "CrystalDATA"
    @sitename.concat(" v0.14.a ")
  end

  def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      current_user: current_user
    }
  end

  def user_not_authorized
    if current_user.compte_démo?
      msg = "Vous n'êtes pas autorisé à effectuer cette action avec le compte démonstration. Veuillez créer un compte pour avoir toutes les fonctionnalités."
    else
      msg = "Vous n'êtes pas autorisé à effectuer cette action."
    end
    flash[:alert] = msg
    redirect_to(request.referrer || authenticated_root_path)
  end

  # def detect_device_format
  #   case request.user_agent
  #   when /iPhone/i, /Android/i && /mobile/i, /Windows Phone/i
  #     request.variant = :phone
  #   else
  #     request.variant = :desktop
  #   end
  # end

protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
