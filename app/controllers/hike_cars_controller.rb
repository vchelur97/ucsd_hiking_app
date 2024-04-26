class HikeCarsController < ApplicationController
  before_action :set_hike
  before_action :set_hike_car, only: %i[show edit update destroy]

  def show
    @hike_car = HikeCar.find(params[:id])
  end

  def new
    @hike_car = @hike.hike_cars.new
  end

  def edit
    @hike_car = HikeCar.find(params[:id])
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

  def set_hike_car
    @hike_car = HikeCar.find(params[:id])
  end

  def hike_car_params
    params.require(:hike_car).permit(:hike_id, :car_id, :spots_available, :pickup_time, :pickup_address, :compensation,
                                     :note)
  end
end
