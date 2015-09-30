class AboutController < ApplicationController
  before_action :authenticate_user!

  def me
  end
end
