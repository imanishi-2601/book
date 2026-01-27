class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    if (user = User.find_by(name: params[:name]))&.authenticate(params[:password]) # この行を変更
      start_new_session_for user
      redirect_to users_path
    else
      redirect_to new_session_path, alert: "Try another name or password."
    end
  end

  def destroy
    terminate_session
    redirect_to after_logout_url, status: :see_other
  end
end
