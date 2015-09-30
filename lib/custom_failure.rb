class CustomFailure < Devise::FailureApp
  def redirect_url
    '/signin'
  end

  # def respond
  #   if http_auth?
  # end
end
