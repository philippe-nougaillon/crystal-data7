class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Pundit::Authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  before_action :authenticate_user!
  before_action :set_layout_variables
  before_action :prepare_exception_notifier
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  before_action :set_tables

  def after_sign_in_path_for(user)
    if user.favorite_table.present?
      table_path(user.favorite_table)
    else
      tables_path
    end
  end

private

  def set_layout_variables
    @sitename ||= "Aikku ACCESS"
  end

  def prepare_exception_notifier
    request.env["exception_notifier.exception_data"] = {
      current_user: current_user
    }
  end

  def user_not_authorized
    if user_signed_in? && current_user.compte_démo?
      msg = t('notice.user.demo_not_authorized')
    else
      msg = t('notice.user.not_authorized')
    end
    flash[:alert] = msg
    redirect_to(request.referrer || authenticated_root_path)
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  def set_tables
    if user_signed_in? && current_user.user?
      @tables = Table.where(id: current_user.team.filters.pluck(:table_id))
    end
  end

protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name])
  end
end
