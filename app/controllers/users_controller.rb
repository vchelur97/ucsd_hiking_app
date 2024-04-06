class UsersController < ApplicationController
  def show
    render :show
  end

  def edit
    render :edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity, alert: "User could not be updated."
    end
  end

  def destroy
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:full_name, :avatar_url)
  end
end
