require 'uri'
require 'twilio-ruby'

class MerryTwilio
  def call_to(tel, datetime, distance)
    client.account.calls.create(
      from: from_phone_number,
      to: make_phone_number(tel),
      url: message2url(create_message(datetime, distance))
    )
  end

  private
  def client
    @client ||= Twilio::REST::Client.new(
      Rails.application.secrets.twilio_account_sid,
      Rails.application.secrets.twilio_auth_token
    )
  end

  def from_phone_number
    '+81332385451'
  end

  def make_phone_number(phone_number)
    phone_number.gsub(/-/, '').gsub(/\A0/, '+81')
  end

  def message2url(message)
    base_url + URI.escape(message) + '%3C%2FSay%3E%0A%3C%2FResponse%3E&'
  end

  def base_url
    "http://twimlets.com/echo?Twiml=%3CResponse%3E%0A%20%20%3CPause%20length%3D%22#{2}%22%2F%3E%0A%20%20%3CSay%20voice%3D%22woman%22%20language%3D%22ja-jp%22%3E"
  end

  def create_message(datetime, distance)
    "私メリーさん。あなたは今日#{datetime.strftime('%H時%M分')}から#{distance}キロメートル歩くの"
  end
end

