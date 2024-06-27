# app/controllers/friends_controller.rb
class FriendsController < ApplicationController
  def all_friends
    @friends = current_user.all_friends
  end

  def add_friends
    @users = User.all
  end

  def show_friend
    @user = User.includes(:posts).strict_loading!(mode: :n_plus_one_only).find(params[:friend_id])
  end


  private
 def friend_params
   params.require(:friend).permit(:id)
 end

  # def set_friends
  #   @friends = current_user.all_friends
  # end

end
