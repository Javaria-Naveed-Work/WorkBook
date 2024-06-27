class FeedsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = current_user
    @posts = Post.includes(:likes, user: :likes).strict_loading!(mode: :n_plus_one_only).where(user: (@user.all_friends + [@user])).order(created_at: :desc)
  end
end
