class PostsController < ApplicationController
  before_action :authorize_request, except: %i[index show]
  before_action :find_post, except: %i[create index]

  def index
    @posts = Post.all
    render json: PostSerializer.new(@posts), status: :ok
  end

  def show
    render json: PostSerializer.new(@post), status: :ok
  end

  def create
    @post = @current_user.posts.build(post_params)

    if @post.save
      render json: PostSerializer.new(@post), status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @post = @current_user.posts.find_by(id: params[:id])

    if @post.update(post_params)
      render json: PostSerializer.new(@post), status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @current_user.posts.find(params[:id]).destroy
  end

  private

  def find_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errros: I18n.t('posts_controller.post_not_found') }, status: :not_found
  end

  def post_params
    params.require(:post).permit(:id, :title, :content)
  end
end
