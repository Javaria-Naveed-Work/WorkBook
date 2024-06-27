class PostsController < ApplicationController

  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy, :like, :unlike]
  def index
    @posts = Post.includes(user: :likes)
  end

  def new
    @post = Post.new
  end

  def show
  end

  def create
    @post = current_user.posts.create(post_params)
    if @post.save
      flash[:notice] = "Post successfully created!"
      redirect_to feed_path
    else
      flash[:alert] = "Post could not be saved"
      render 'new'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "Post successfully updated!"
      if request.referer.include?("feed")
        redirect_to feed_path
      else
        redirect_to profile_path
      end
    else
      flash[:alert] = "Post could not be updated"
      render 'edit'
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = "Post successfully deleted!"
      redirect_to redirect_path
    else
      flash[:alert] = "Post could not be deleted"
      render json: @post.errors.full_messages
    end
  end

  def like
    @post.likes.create(user: current_user)
    flash[:notice] = "You liked the post"
    redirect_to redirect_path
  end

  def unlike
    @like = @post.likes.find_by(user: current_user)

    if @like
      @like.destroy
      flash[:notice] = "You unliked the post"
    else
      flash[:alert] = "You haven't liked this post"
    end

    redirect_to redirect_path
  end

  private

  def post_params
    params.require(:post).permit(:content, :pic)
  end

  def set_post
    @post = Post.includes(:user, :likes, comments: [:user, replies: :user]).strict_loading!(mode: :n_plus_one_only).find_by(id:params[:id])
    if @post.nil?
      flash[:alert] = "Post not found"
      redirect_to feed_path
    end
  end

  def redirect_path
    request.referer.include?("profile") ? profile_path : feed_path
  end
end
