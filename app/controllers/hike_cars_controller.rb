class HikeCarsController < ApplicationController
  before_action :set_hike, only: %i[new create]
  before_action :set_hike_car, only: %i[show edit update destroy]

  def show
    @hike_car = HikeCar.find(params[:id])
  end

  def new
    @hike_car = @hike.hike_cars.new
  end

  def edit
  end

  def create
    @hike_car = @hike.hike_cars.create!(hike_car_params)
    hike_car_notification

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

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @hike, notice: "Successfully removed car from the hike" }
    end
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

  def hike_car_notification
    title = "New car added"
    body = "A new car has been added to the #{@hike.title} hike!"
    icon = @hike.graphic.attached? ? url_for(@hike.graphic) : '/assets/hiking_logo.svg'
    link = hike_url(@hike)

    subscribed_users = User.find(@hike.subscribers)
    notify_users(subscribed_users, title, body, icon, link)
  end
end
