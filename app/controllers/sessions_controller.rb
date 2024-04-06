class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, :signed_waiver!
  def new
    render :new
  end

  def create
    user, first_time = User.create_from_omniauth(auth)
    session = user.sessions.create
    cookies.signed[:session_id] = session.id
    if first_time
      redirect_to edit_user_path(user), notice: 'Welcome! Please complete your profile.'
    else
      redirect_to root_path, notice: 'Logged in!'
    end
  end

  def destroy
    session = Session.find(cookies.signed[:session_id])
    session.destroy
    cookies.delete(:session_id)
    redirect_to root_path, notice: 'Logged out!'
  end

  private

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end
