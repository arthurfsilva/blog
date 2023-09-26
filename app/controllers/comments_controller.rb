class CommentsController < ApplicationController
  before_action :find_comment, except: %i[create index]
  before_action :find_post, only: %i[create]

  def index
    @comments = Comment.all
    render json: CommentSerializer.new(@comments), status: :ok
  end

  def show
    render json: CommentSerializer.new(@comment), status: :ok
  end

  def create
    @comment = @post.comments.build(comment_params)

    if @comment.save
      render json: CommentSerializer.new(@comment), status: :created
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @comment.update(comment_params)
      render json: CommentSerializer.new(@comment), status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
  end

  private

  def find_post
    @post = Post.find(params[:post_id])
  end

  def find_comment
    @comment = Comment.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { errros: I18n.t('posts_controller.post_not_found') }, status: :not_found
  end

  def comment_params
    params.require(:comment).permit(:id, :name, :body)
  end
end
