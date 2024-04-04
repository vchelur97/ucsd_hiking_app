class ApplicationController < ActionController::Base
  helper_method :user

  private

  def user
    @user ||= Session.find_by(id: cookies.signed[:session_id])&.user
  end

  def authenticate_user!
    redirect_to new_user_session_path unless user
  end
end
