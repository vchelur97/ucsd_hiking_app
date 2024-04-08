class UsersController < ApplicationController
  skip_before_action :added_phone_number!

  def show
    render :show
  end

  def edit
    render :edit
  end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: "Profile was successfully updated."
    else
      render :edit, status: :unprocessable_entity, alert: "Profile could not be updated."
    end
  end

  def destroy
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:preferred_name, :phone_no, :discord)
  end
end
