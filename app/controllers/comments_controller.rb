class CommentsController < ApplicationController
  before_action :set_post
  before_action :find_comment, only: [:create_reply, :edit, :destroy]

  def create
    @comment = @post.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:success] = "Comment created!"
      redirect_to @post
    else
      flash.now[:alert] = "Comment not created!"
      redirect_to @post
    end
  end

  def edit
  end

  def update
    if @comment.update(comment_params)
      flash[:success] = "Comment updated!"
      redirect_to @post
    else
      flash.now[:alert] = "Comment not updated!"
      render json: "error", status: 422
    end
  end

  def destroy
    if @comment.destroy
      flash[:success] = "Comment deleted!"
    else
      flash[:alert] = "Comment not deleted!"
    end
    redirect_to @post
  end

  def create_reply
    @reply = Comment.new(comment_params)
    @reply.parent_id = params[:comment_id]
    @reply.user = current_user
    @reply.post = @post

    if @reply.save
      flash[:success] = "Reply created!"
      redirect_to @post
    else
      flash.now[:alert] = "Reply not created!"
      redirect_to @post
    end
  end

  private

  def set_post
    @post = Post.find_by(id: params[:post_id])
    if @post.nil?
      flash[:alert] = "Post not found"
      redirect_to posts_path
    end
  end

  def find_comment
    @comment = Comment.find_by(params[:id])
    if @comment.nil?
      flash[:alert] = "Comment not found"
      redirect_to @post
    end
    # @post.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:comment_id, :content, :post_id)
  end
end
