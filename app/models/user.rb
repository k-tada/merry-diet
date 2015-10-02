class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  def self.find_for_backlog_oauth(auth, space_id, signed_in_resource = nil)
    user = User.where( provider: auth.provider, uid: auth.uid ).first

    if user
      user.update!(token: auth.credentials.token)
    else
      user = User.create(
        name:     auth.extra.raw_info.name,
        provider: auth.provider,
        uid:      auth.uid,
        email:    auth.info.email,
        password: Devise.friendly_token[0, 20],
        token:    auth.credentials.token,
        space_id: space_id
      )
    end
    user
  end
end
