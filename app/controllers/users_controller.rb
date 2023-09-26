class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create index]

  def index
    @users = User.all
    render json: UserSerializer.new(@users), status: :ok
  end

  def show
    render json: UserSerializer.new(@user), status: :ok
  end

  def create
    @user = User.new(user_params)

    if @user.save
      render json: UserSerializer.new(@user), status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity unless @user.update(user_params)

    render json: UserSerializer.new(@user), status: :ok
  end

  def destroy
    @user.destroy
  end

  private

  def find_user
    @user = User.find(user_params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errors: I18n.t('users_controller.user_not_found') }, status: :not_found
  end

  def user_params
    params.permit(
      :id, :name, :email, :password, :password_confirmation
    )
  end
end
