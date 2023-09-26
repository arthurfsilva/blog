class ApplicationController < ActionController::API
  def not_found
    render json: { error: I18n.t('application_controller.not_found') }, status: :not_found
  end

  def authorize_request
    token = split_header

    begin
      @decoded = JsonWebToken.decode(token)
      @current_user = User.find(@decoded[:user_id])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound => error
      render json: { errors: error.message }, status: :unauthorized
    end
  end

  private

  def split_header
    header = request.headers['Authorization']

    header&.split(' ')&.last
  end
end
