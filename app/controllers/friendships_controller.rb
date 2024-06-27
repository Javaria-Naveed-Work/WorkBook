class FriendshipsController < ApplicationController
  before_action :set_user, only: [:create, :update, :destroy]

  def create
    # puts friendship_params[:id]
    # puts friendship_params[:user_id]
    @friendship = current_user.friendships.build(friend_id: @user.id, status: 'pending')
    if @friendship.save
      flash[:notice] = "Friend request sent."
    else
      flash[:alert] = "Unable to send friend request."
    end
    redirect_to add_friends_path
  end

  def update
    @friendship = Friendship.find_by(user_id: @user.id, friend_id: current_user.id)
    if @friendship.update(status: 'accepted')
      flash[:notice] = "Friend request accepted."
    else
      flash[:alert] = "Unable to accept friend request."
    end
    redirect_to add_friends_path
  end

def destroy
  @friendship = Friendship.find_by(user_id: @user.id, friend_id: current_user.id) || Friendship.find_by(user_id: current_user.id, friend_id: @user.id)
  if @friendship.destroy!
    flash[:notice] = "Friendship Broken."
  else
    flash[:alert] = "Unable to break friendship ties."
  end
  redirect_to add_friends_path
end

private

def set_user
  puts params[:user_id]
  @user = User.find(params[:id])
end


  def friendship_params
    params.require(:friendship).permit(:id)
  end

end
