class CommentsController < ApplicationController
  before_action :find_post
  before_action :find_comment, only: [:create_reply, :edit, :update, :destroy]

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
      render json:"error", status: 422
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
    @reply = @comment.replies.new(comment_params)
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
  def find_post
    @post = Post.strict_loading.find(params[:post_id])
  end

  def find_comment
    @comment = @post.comments.strict_loading!.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:comment_id, :content, :post_id)
  end
end
