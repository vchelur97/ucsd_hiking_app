class HikeParticipantsController < ApplicationController
  before_action :set_hike_car, only: %i[new create]
  before_action :set_hike_participant, only: %i[show edit destroy]

  def show
  end

  def new
    @hike_participant = @hike_car.participants.new
  end

  def edit
  end

  def create
    @hike_participant = @hike_car.participants.create!(hike_participant_params)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @hike, notice: "Successfully joined the hike" }
    end
  end

  def destroy
    @hike_participant.destroy!
    redirect_to hike_participants_url, notice: "Removed from hike"
  end

  private

  def set_hike_car
    @hike_car = HikeCar.find(params[:hike_car_id])
  end

  def set_hike_participant
    @hike_participant = HikeParticipant.find(params[:id])
  end

  def hike_participant_params
    params.require(:hike_participant).permit(:hike_car_id, :user_id, :position, :pickup_info)
  end
end
