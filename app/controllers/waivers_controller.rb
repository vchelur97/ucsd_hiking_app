class WaiversController < ApplicationController
  skip_before_action :signed_waiver!, :added_phone_number!

  def new
    redirect_to root_path, warning: "Waiver is already signed" if signed_waiver?
    @waiver = Waiver.new
  end

  def create
    redirect_to root_path, warning: "Waiver is already signed" if signed_waiver?
    waiver = Waiver.new(user:, version: Waiver::LATEST_VERSION, ip_address: request.remote_ip,
                        user_agent: request.user_agent)
    if waiver.save
      redirect_to root_path, success: "Waiver was successfully signed"
    else
      render :show, status: :unprocessable_entity, alert: "Waiver could not be signed"
    end
  end

  def show
    @waiver = @user.waivers.last
  end
end
