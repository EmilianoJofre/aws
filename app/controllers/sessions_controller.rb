class SessionsController < ApplicationController
  before_action :validate_email, only: [:reset_password]

  def recovery_password
    @model_name = model_params
  end

  def reset_password
    can_reset = ResetUserPassword.for(user_type: model, email: user_params[:email], request: request)
    key = can_reset ? 'email_sent' : 'email_failed'
    redirect_to '/', notice: I18n.t("devise.password.user.#{key}")
  end

  def edit_password
    redirect_to '/' unless token_params[:token].present? || logged_user.present?
    @model_name = model_params
    @token = token_params[:token]
  end

  def update_password
    if password_params[:token].present?
      model.reset_password_by_token(
        reset_password_token: password_params[:token],
        password: password_params[:password],
        password_confirmation: password_params[:password_confirmation]
      )
    elsif logged_user.present?
      logged_user.reset_password(
        password_params[:password],
        password_params[:password_confirmation]
      )
    end

    redirect_to '/'
  end

  private

  def model
    model_params.capitalize.constantize
  end

  def validate_email
    @user = model.find_by(email: user_params[:email])

    if @user.nil?
      redirect_to '/', alert: I18n.t('devise.password.user.invalid')
    end

    !@user.nil?
  end

  def logged_user
    send("current_#{model_params}")
  end

  def model_params
    params.require(:user_type)
  end

  def password_params
    params.permit(:token, :password, :password_confirmation)
  end

  def user_params
    params[:email] = params[:email].downcase
    params.permit(:email)
  end

  def token_params
    params.permit(:token)
  end
end
