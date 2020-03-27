class Api::BaseController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include Api::Helpers
  include Api::AuthHelpers
  include Api::ErrorHandler
  before_action :authenticate_with_token
  respond_to :js

  delegate :t, to: I18n

  # This had to be extracted out of AuthHelpers as it was conflicting with web controller current_user
  def current_user
    @api_current_user
  end
end