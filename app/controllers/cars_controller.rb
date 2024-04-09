class CarsController < ApplicationController
  def new
    @car = @user.cars.new
  end

  def show
  end

  def edit
    @car = @user.cars.find(params[:id])
  end

  def create
    @car = @user.cars.create!(car_params)
    if @car.save
      redirect_to @user, success: "Car was successfully created"
    else
      redirect_to @user, status: :unprocessable_entity, alert: "Car could not be created"
    end
  end

  def update
    @car = @user.cars.find(params[:id])
    if @car.update(car_params)
      redirect_to @user, success: "Car was successfully updated"
    else
      redirect_to @user, status: :unprocessable_entity, alert: "Car could not be updated"
    end
  end

  def destroy
    @car = @user.cars.find(params[:id])
    @car.destroy!
    redirect_to @user, success: "Car was successfully removed"
  end

  private

  def car_params
    params.require(:car).permit(:user_id, :make, :model, :color, :capacity, :license_plate, :mpg)
  end
end
