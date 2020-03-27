module Api
  module AuthHelpers
    extend ActiveSupport::Concern

    def authenticate_with_token
      authenticate_with_http_token do |token, options|
        @api_current_user = User.find_by(auth_token: token)
      end
      render_unauthorized unless @api_current_user.present?
    end

    def render_unauthorized
      headers['WWW-Authenticate'] = 'Token realm="Application"'
      render json: { error: 'Invalid auth token' }, status: :unauthorized
    end

    def current_user?(user)
      user == @api_current_user
    end

    def check_ownership
      render_unauthorized unless @user == @api_current_user
    end
  end
end
