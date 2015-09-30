class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def backlog
    @user = User.find_for_backlog_oauth(request.env['omniauth.auth'], session['omniauth.backlog.space_id'], current_user)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
    else
      session['devise.backlog_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end
end
