class CarsController < ApplicationController
  def new
    @car = @user.cars.new
  end

  def show
  end

  def edit
  end

  def create
    @car = @user.cars.create!(car_params)
    if @car.save
      redirect_to @user, notice: "Car was successfully created"
    else
      redirect_to @user, status: :unprocessable_entity, alert: "Car could not be created"
    end
  end

  def update
    if @car.update(car_params)
      redirect_to @user, notice: "Car was successfully updated"
    else
      redirect_to @user, status: :unprocessable_entity, alert: "Car could not be updated"
    end
  end

  def destroy
    @car.destroy!
    redirect_to @user, notice: "Car was successfully removed"
  end

  private

  def car_params
    params.require(:car).permit(:user_id, :make, :model, :color, :capacity, :license_plate, :mpg)
  end
end
