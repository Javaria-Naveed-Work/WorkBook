class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  # after_action -> {
  #   puts response.status
  # }

  protected

  # def set_user
  #   @user = current_user
  # end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:profile_photo, :cover_photo])
  end

  def after_sign_in_path_for(resource)
    feed_path
  end

  def after_sign_up_path_for(resource)
     feed_path
  end

  def after_sign_out_path_for(resource)
    sign_in_path
  end


end
