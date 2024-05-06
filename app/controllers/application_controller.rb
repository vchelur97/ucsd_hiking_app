class ApplicationController < ActionController::Base
  include Pagy::Backend
  helper_method :user, :signed_waiver?
  before_action :authenticate_user!, :signed_waiver!, :added_phone_number!
  around_action :set_time_zone
  add_flash_types :success, :warning

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
    redirect_to new_user_waiver_path, info: "Please sign the waiver" unless signed_waiver?
  end

  def added_phone_number!
    redirect_to edit_user_path, warning: "Add phone number to participate in hikes" unless user.phone_no.present?
  end

  def set_time_zone(&block)
    Time.use_zone("Pacific Time (US & Canada)", &block)
  end

  def notify_users(users, title, body, icon, link)
    users.each do |user|
      SendNotificationsJob.perform_later(user, title, body, icon, link)
    end
  end

end
