class Api::V1::CallbacksController < Api::BaseController
  skip_before_action :authenticate_with_token
  before_action :verify_firebase_token, :validate_mobile_number, :validate_uid, :validate_id_token
  before_action :validate_name, only: :mobile_sign_up

  def mobile_login
    @user = User.consumers.find_by!(mobile: mobile_provider_params[:mobile])
    render_success
  end

  def mobile_sign_up
    @user = User.find_or_initialize_by(mobile: mobile_provider_params[:mobile])
    @user.update(name: mobile_provider_params[:name])
    @user.save_provider_auth_user
    if @user.persisted? && @user.identities.find_or_create_by(provider: 'mobile', uid: mobile_provider_params[:uid])
      render_succes
    else
      @error_message = t('callbacks.oauth_failure')
      logger.error("User or identity creation failed. errors: #{@user.errors.full_messages}")
      render_failure
    end
  end

  private

  def verify_firebase_token
    body = {idToken: mobile_provider_params[:id_token]}
    api_response = HTTParty.post("https://www.googleapis.com/identitytoolkit/v3/relyingparty/getAccountInfo?key=#{ENV['firebase_admin_api_key']}", body: body)
    unless api_response.code == 200 && api_response['users'].first['phoneNumber'] == '+91' + mobile_provider_params[:mobile]
      logger.error("Firebase idToken verification failed. body: #{api_response}, status: #{api_response.code}, params: #{mobile_provider_params}")
      render json: { error: t('callbacks.provider_token_verification_failure') }, status: :unprocessable_entity
    end
  end

  def validate_mobile_number
    return if mobile_provider_params[:mobile]
    render json: { error: t('general.required_field', field: 'Mobile number') }, status: :unprocessable_entity
  end

  def validate_uid
    return if mobile_provider_params[:uid]
    logger.error("Firebase uid not passed in params. params: #{mobile_provider_params}")
    render json: { error: t('callbacks.provider_token_verification_failure') }, status: :unprocessable_entity
  end

  def validate_name
    return if mobile_provider_params[:name]
    render json: { error: t('general.required_field', field: 'Name')}, status: :unprocessable_entity
  end

  def validate_id_token
    return if mobile_provider_params[:id_token]
    logger.error("Firebase token not passed in params. params: #{mobile_provider_params}")
    render json: { error: t('callbacks.provider_token_verification_failure') }, status: :unprocessable_entity
  end

  def render_success
    render json: { auth_token: @user.fetch_auth_token, id: @user.id }, status: :ok
  end

  def render_failure
    render json: { error: @error_message }, status: :bad_request
  end

  def mobile_provider_params
    params.require(:user).permit(:provider, :uid, :mobile, :name, :id_token)
  end
end