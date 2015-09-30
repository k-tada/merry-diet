class CustomFailure < Devise::FailureApp
  def redirect_url
    '/signin'
  end
end
