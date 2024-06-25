# app/controllers/profiles_controller.rb
class ProfilesController < ApplicationController
  before_action :authenticate_user!
  def show
    @user = current_user
    @posts = @user.posts.includes(:user, :likes).order(created_at: :desc)
  end

  def update_cover_photo
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: 'Cover photo was successfully updated.'
    else
      flash[:alert] = 'There was an error updating the cover photo.'
      render :show
    end
  end

  def update_profile_photo
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: 'Profile photo was successfully updated.'
    else
      flash[:alert] = 'There was an error updating the profile photo.'
      render :show
    end
  end

  private

  def user_params
    params.require(:user).permit(:cover_photo, :profile_photo)
  end
end
