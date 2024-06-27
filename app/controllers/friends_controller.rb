class FriendsController < ApplicationController

  before_action :set_search_results, only: [:add_friends]

  def all_friends
    @friends = current_user.all_friends
  end

  def add_friends
    # @users = User.all #removed unless current_user == user from view and added logic below
    @users = User.all.reject { |friend| friend == current_user }
  end

  def show_friend
    @user = User.includes(:posts).strict_loading!(mode: :n_plus_one_only).find(params[:friend_id])
  end

  private

  def friend_params
    params.require(:friend).permit(:id)
  end

  def set_search_results
    if params[:query].present?
      @search_results = User.where('name LIKE ?', "%#{params[:query]}%").reject { |user| user == current_user }
    else
      @search_results = []
    end
  end

end
