class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:show]

  def new
    render :new
  end

  def create
    user = User.from_omniauth(auth)
    if user.present?
      flash[:success] = t 'user.create.success', kind: 'Google'
      session[:user_id] = user.id
    else
      flash[:alert] = t 'user.create.failure', kind: 'Google', reason: "#{auth.info.email} is not authorized."
    end
    redirect_to root_path
  end

  def show
    render :show
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end
