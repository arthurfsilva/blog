class AuthenticationController < ApplicationController
  before_action :authorize_request, except: :login

  def login
    @user = User.find_by(email: authentication_params[:email])

    if @user&.authenticate(authentication_params[:password])
      token = JsonWebToken.encode(user_id: @user.id)

      render json: { token: }, status: :ok
    else
      render json: { errors: I18n.t('authentication_controller.unauthorized') }, status: :unauthorized
    end
  end

  def authentication_params
    params.permit(:email, :password)
  end
end
