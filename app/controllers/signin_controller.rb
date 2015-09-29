class SigninController < ApplicationController
  def index
  end

  def auth
    raise 'No SpaceID Specified' if params[:space_id].blank?
    session['omniauth.backlog.space_id'] = params[:space_id]
    redirect_to user_omniauth_authorize_path(:backlog)
  end
end
