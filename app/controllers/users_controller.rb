class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:setting, :update_setting]
  before_action :set_user, only: [:setting, :update_setting]

  def setting
  end

  def update_setting
    if valid? and @user.update(user_params)
      redirect_to tasks_path
    else
      redirect_to '/users/setting', :alert => @error
    end
  end

  private
  def set_user
    @user = current_user
  end
  def user_params
    params.require(:user).permit(:phone_number)
  end
  def valid?
    ret = user_params[:phone_number].present?
    @error = '電話番号を入力してよね' unless ret
    ret
  end
end
