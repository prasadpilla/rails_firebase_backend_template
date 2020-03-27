class Api::V1::UsersController < Api::BaseController
  before_action :set_user, only: %i[show update info]
  before_action :check_ownership, only: %i[show update info]

  def show
    render json: {user: UserSerializer.new(@user).as_json}
  end

  def info
    render json: UserSerializer.new(@user).as_json
  end

  def update
    if @user.update(user_params.except(:vehicles))
      render json: UserSerializer.new(@user).as_json
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def register_notification_token
    @notification_token = current_user.notification_tokens.find_or_initialize_by(value: notification_token_params[:token])
    if @notification_token.save
      render json: {}, status: :created
    else
      render_error(:unprocessable_entity, @notification_token.errors.full_messages.to_sentence)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :mobile, :profile_picture)
  end

  def set_user
    @user = User.find_by!(id: params[:id])
  end

  def notification_token_params
    params.require(:user).permit(:token)
  end
end
