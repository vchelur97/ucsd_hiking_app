class CarsController < ApplicationController
  before_action :set_car, only: %i[show edit update destroy]

  def new
    @car = @user.cars.new
  end

  def show
  end

  def edit
  end

  def create
    @car = @user.cars.new(car_params)
    if @car.save
      redirect_to @user, success: "Car was successfully created"
    else
      redirect_to @user, alert: "Car could not be created. Make sure to fill out all required fields."
    end
  end

  def update
    @car = @user.cars.find(params[:id])
    if @car.update(car_params)
      redirect_to @user, success: "Car was successfully updated"
    else
      redirect_to @user, alert: "Car could not be updated. Make sure to fill out all required fields."
    end
  end

  def destroy
    @car = @user.cars.find(params[:id])
    @car.destroy!
    redirect_to @user, success: "Car was successfully removed"
  end

  private

  def set_car
    @car = Car.find(params[:id])
  end

  def car_params
    params.require(:car).permit(:user_id, :make, :model, :color, :capacity, :license_plate, :mpg)
  end
end
