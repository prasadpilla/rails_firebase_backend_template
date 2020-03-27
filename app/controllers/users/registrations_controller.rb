class Users::RegistrationsController < Devise::RegistrationsController
  include ApplicationHelper
  include Api::Helpers

  respond_to :json
  protect_from_forgery with: :exception, prepend: true
  skip_before_action :verify_authenticity_token, if: :json_request?

  def create
    user = sign_up_params[:email].present? ? User.find_by(email: sign_up_params[:email]) : nil
    if user.present?
      process_existing_user(user)
    else
      create_new_user
    end
  end

  def process_existing_user(user)
    if email_identity_exists?(user)
      set_flash_message! :notice, :email_exists
      respond_to do |format|
        format.html { respond_with resource, location: new_user_registration_path }
        format.json { render json: { error: t('devise.registrations.user.email_exists') }, status: :unprocessable_entity }
      end
    elsif oauth_provider_exists?(user)
      existing_oauth_user(user)
    end
  end

  def create_new_user
    build_resource(sign_up_params)
    resource.save
    yield resource if block_given?
    if resource.persisted?
      create_identity(resource)
    else
      cleanup(resource)
    end
  end

  def existing_oauth_user(user)
    message_hash = begin
      custom_message_hash(user)
    rescue
      { providers: 'a social profile', variable_message: 'that' }
    end
    error_message = t('devise.registrations.user.outh_exists', providers: message_hash[:providers],
                      variable_message: message_hash[:variable_message])
    set_flash_message! :notice, error_message
    respond_to do |format|
      format.html { respond_with resource, location: new_user_registration_path }
      format.json { render json: { error: error_message }, status: :unprocessable_entity}
    end
  end

  def create_identity(resource)
    if resource.active_for_authentication?
      active_sign_up(resource)
    else
      inactive_sign_up(resource)
    end
  end

  def cleanup(resource)
    clean_up_passwords resource
    set_minimum_password_length
    respond_to do |format|
      format.html { respond_with resource }
      format.json { render json: { errors: resource.errors }, status: :unprocessable_entity }
    end
  end

  def active_sign_up(resource)
    create_email_identity(resource)
    set_flash_message! :success, :signed_up
    sign_up(resource_name, resource)

    respond_to do |format|
      format.html { respond_with resource, location: after_sign_up_path_for(resource) }
      format.json { render json: { message: flash[:success] }, status: :created}
    end
  end

  def inactive_sign_up(resource)
    create_email_identity(resource)
    error_message = t("devise.registrations.signed_up_but_#{resource.inactive_message}")
    flash[:notice] = error_message
    expire_data_after_sign_in!

    respond_to do |format|
      format.html { respond_with resource, location: after_inactive_sign_up_path_for(resource)  }
      format.json { render json: { error: error_message }, status: :created}
    end
  end

  protected

  # Build a devise resource passing in the session. Useful to move
  # temporary session data to the newly created user.
  def build_resource(hash = nil)
    self.resource = resource_class.new_with_session(hash || {}, session)
  end

  # Signs in a user on sign up. You can overwrite this method in your own
  # RegistrationsController.
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
  end

  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    new_user_session_path
  end

  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end

  def oauth_provider_exists?(user)
    user ? user.identities.where.not(provider: 'email').exists? : false
  end

  def email_identity_exists?(user)
    user ? user.identities.where(provider: 'email').exists? : false
  end

  def create_email_identity(resource)
    resource.identities.create(provider: 'email')
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
