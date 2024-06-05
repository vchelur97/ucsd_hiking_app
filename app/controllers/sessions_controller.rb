class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, :no_access!, :signed_waiver!, :added_phone_number!
  def new
  end

  def create
    user, first_time = User.create_from_omniauth(auth)
    session = user.sessions.create
    cookies.signed[:session_id] = session.id
    if first_time
      redirect_to edit_user_path(user), notice: 'Welcome! Please complete your profile'
    else
      redirect_to root_path
    end
  end

  def update
    session = Session.find(cookies.signed[:session_id])
    session.update!(push_endpoint: params[:push_endpoint], push_p256dh: params[:push_p256dh],
                    push_auth: params[:push_auth])
    render json: { status: 'success' }
  end

  def destroy
    session = Session.find(cookies.signed[:session_id])
    session.destroy
    cookies.delete(:session_id)
    redirect_to root_path, success: 'Logged out!'
  end

  private

  def auth
    @auth ||= request.env['omniauth.auth']
  end
end
