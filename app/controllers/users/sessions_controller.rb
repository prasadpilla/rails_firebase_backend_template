class Users::SessionsController < Devise::SessionsController
  include ApplicationHelper
  include Api::Helpers
  skip_before_action :verify_authenticity_token, if: :json_request?
  respond_to :json

  def create
    user = sign_in_params[:email].present? ? User.find_by(email: sign_in_params[:email]) : nil
    if oauth_provider_exists?(user) && !email_identity_exists?(user)
      check_oauth_exists(user)
    else
      create_session_email
    end
  end

  def check_oauth_exists(user)
    message_hash = begin
      custom_message_hash(user)
    rescue
      { providers: 'a social profile', variable_message: 'that' }
    end
    error_message = t('devise.sessions.user.outh_exists', providers: message_hash[:providers],
                      variable_message: message_hash[:variable_message])
    set_flash_message! :notice, error_message
    respond_to do |format|
      format.html { respond_with resource, location: root_path }
      format.json { render json: { error: error_message }, status: :unprocessable_entity }
    end
  end

  def create_session_email
    self.resource = warden.authenticate!(auth_options)
    set_flash_message!(:success, :signed_in)
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_to do |format|
      format.html { respond_with resource, location: after_sign_in_path_for(resource) }
      format.json { render json: { auth_token: resource.fetch_auth_token, id: resource.id }, status: :ok }
    end
  end

  private

  def oauth_provider_exists?(user)
    user ? user.identities.where.not(provider: 'email').exists? : false
  end

  def email_identity_exists?(user)
    user ? user.identities.where(provider: 'email').exists? : false
  end

  def custom_message_hash(user)
    message_hash = {}
    provider_array = user.identities.pluck(:provider)
    message_hash[:providers] = provider_array.map { |x| x == 'google_oauth2' ? 'Google' : x.camelize }.join(' and ')
    message_hash[:variable_message] = if provider_array.length > 1
                                        'any of them'
                                      else
                                        'that'
                                      end
    message_hash
  end
end
