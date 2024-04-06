class ApplicationController < ActionController::Base
  helper_method :user, :signed_waiver?
  before_action :authenticate_user!, :signed_waiver!

  private

  def user
    session = Session.find_by(id: cookies.signed[:session_id])
    cookies.delete(:session_id) unless session
    @user ||= session&.user
  end

  def authenticate_user!
    redirect_to new_user_session_path unless user
  end

  def signed_waiver?
    waiver = Waiver.where(user:).last
    waiver && waiver.version == Waiver::LATEST_VERSION
  end

  def signed_waiver!
    redirect_to new_user_waiver_path unless signed_waiver?
  end
end
