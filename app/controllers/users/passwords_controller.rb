class Users::PasswordsController < Devise::PasswordsController
  include Api::AuthHelpers
  include Api::Helpers

  skip_before_action :verify_authenticity_token, if: :json_request?
  respond_to :json

  def update
    self.resource = resource_class.reset_password_by_token(resource_params)
    yield resource if block_given?

    if resource.errors.empty?
      process_password_update(resource)
    else
      set_minimum_password_length
      respond_with resource
    end
  end

  def process_password_update(resource)
    create_email_identity(resource) unless email_identity_exists?(resource)
    resource.unlock_access! if unlockable?(resource)
    if Devise.sign_in_after_reset_password
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message!(:notice, flash_message)
      sign_in(resource_name, resource)
    else
      set_flash_message!(:notice, :updated_not_active)
    end
    respond_with resource, location: after_resetting_password_path_for(resource)
  end

  protected

  def after_resetting_password_path_for(resource)
    Devise.sign_in_after_reset_password ? after_sign_in_path_for(resource) : new_session_path(resource_name)
  end

  # Check if proper Lockable module methods are present & unlock strategy
  # allows to unlock resource on password reset
  def unlockable?(resource)
    resource.respond_to?(:unlock_access!) &&
      resource.respond_to?(:unlock_strategy_enabled?) &&
      resource.unlock_strategy_enabled?(:email)
  end

  def email_identity_exists?(resource)
    resource ? resource.identities.where(provider: 'email').exists? : false
  end

  def create_email_identity(resource)
    resource.identities.create(provider: 'email')
  end
end
