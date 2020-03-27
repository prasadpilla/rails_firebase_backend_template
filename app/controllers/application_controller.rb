class ApplicationController < ActionController::Base
  include ExceptionHandlers

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!

  def handle_unverified_request
    flash[:error] = I18n.t('general.csrf_token_expired')
    redirect_back(fallback_location: root_path)
  end

  protected

  def configure_permitted_parameters
    attributes = [:name, :email, :country_code, :mobile]
    devise_parameter_sanitizer.permit(:sign_up, keys: attributes)
    devise_parameter_sanitizer.permit(:account_update, keys: attributes)
  end
end
