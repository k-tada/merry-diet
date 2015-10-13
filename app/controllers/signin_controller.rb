class SigninController < ApplicationController
  def index
  end

  def auth
    if params[:space_id].blank?
      redirect_to '/signin', alert: 'Backlog Space IDを入力してください'
    else
      session['omniauth.backlog.space_id'] = params[:space_id]
      redirect_to user_omniauth_authorize_path(:backlog)
    end
  end
end
