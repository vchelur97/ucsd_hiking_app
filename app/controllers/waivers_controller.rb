class WaiversController < ApplicationController
  skip_before_action :signed_waiver!

  def new
    @waiver = Waiver.new
  end

  def create
    waiver = Waiver.new(user:, version: Waiver::LATEST_VERSION, ip_address: request.remote_ip,
                        user_agent: request.user_agent)
    if waiver.save
      redirect_to user_path, notice: "Waiver was successfully signed."
    else
      render :show, status: :unprocessable_entity
    end
  end
end
