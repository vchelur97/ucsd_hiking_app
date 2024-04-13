class HikeCarsController < ApplicationController
  before_action :set_hike, only: %i[new create]

  def show
  end

  def new
    @hike_car = @hike.hike_cars.new
  end

  def edit
  end

  def create
    @hike_car = @hike.hike_cars.create!(hike_car_params)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @hike, notice: "Car has been added to the hike" }
    end
  end

  def update
    if @hike_car.update(hike_car_params)
      redirect_to hike_car_url(@hike_car), notice: "Hike car was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @hike_car.destroy!
    redirect_to hike_cars_url, notice: "Hike car was successfully destroyed."
  end

  private

  def set_hike
    @hike = Hike.find(params[:hike_id])
  end

  def hike_car_params
    params.require(:hike_car).permit(:hike_id, :car_id, :spot_info, :pickup_info)
  end
end
