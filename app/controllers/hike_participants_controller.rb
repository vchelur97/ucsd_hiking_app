class HikeParticipantsController < ApplicationController
  before_action :set_hike_car, only: %i[new create]

  def show
  end

  def new
    @hike_participant = @hike_car.hike_participants.new
  end

  def edit
  end

  def create
    @hike_participant = @hike_car.hike_participants.create!(hike_participant_params)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @hike, notice: "Successfully joined the hike" }
    end
  end

  def update
    if @hike_participant.update(hike_participant_params)
      redirect_to hike_participant_url(@hike_participant), notice: "Hike car was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @hike_participant.destroy!
    redirect_to hike_participants_url, notice: "Removed from hike"
  end

  private

  def set_hike_car
    @hike_participant = HikeCar.find(params[:hike_car_id])
  end

  def hike_participant_params
    params.require(:hike_participant).permit(:hike_car_id, :user_id, :position, :pickup_info)
  end
end
