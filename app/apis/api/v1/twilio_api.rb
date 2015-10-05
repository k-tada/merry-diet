module API
  module V1
    class TwilioApi < Grape::API

# ¦controller‚ÌŽÀ‘•‚Í–³—‚¾‚Á‚½‚Ì‚Å‚»‚ê‚Á‚Û‚¢ƒKƒ‚¾‚¯
#      helpers do
#        params :requires do
#          requires :account_sid, type: String, desc: 'Twilio AccountSID'
#          requires :auth_auth_token, type: String, desc: 'Twilio AuthToken'
#        end
#
#        params :call do
#          requires :to_tel, type: String, desc: 'Twilio Calling number'
#          requires :from_tel, type: String, desc: 'Twilio Originating number'
#          requires :url, type: String, desc: 'Twilio TWiML URL'
#        end
#
#        def twilio(params)
#          @twilio ||= Twilio.new(params[:account_sid], params[:auth_token])
#        end
#      end
#
#      params do
#        use :requires
#      end

      resource :twilio do
        resource :call do
          desc 'GET /api/v1/twilio/call'
          get '/' do
            # ¦controller‚ÌŽÀ‘•‚Í–³—‚¾‚Á‚½‚Ì‚Å‚»‚ê‚Á‚Û‚¢ƒKƒ‚¾‚¯
            # present twilio(params).call(params[:to_tel], params[:from_tel], params[:url]), with: API::V1::Entities::Twilio::TwilioEntity


            # ¦ƒxƒ^‘‚«EE
            require 'rubygems' # not necessary with ruby 1.9 but included for completeness
            require 'twilio-ruby'

            # put your own credentials here
            account_sid = 'AC57be6cacbf7f5d72bd7e20e7aa35ade9'
            auth_token = 'b2545f0fc3690f8be9eac522e3cecae9'

            # set up a client to talk to the Twilio REST API
            @client = Twilio::REST::Client.new account_sid, auth_token

            call = @client.account.calls.create({
                :to => '+819079110141',
                :from => '+819079110141',
                :url => 'http://twimlets.com/echo?Twiml=%3CResponse%3E%0A%20%20%3CPause%20length%3D%225%22%2F%3E%0A%20%20%3CSay%20voice%3D%22woman%22%20language%3D%22ja-jp%22%3E%E3%83%88%E3%82%A5%E3%82%A4%E3%83%AA%E3%82%AA%E3%81%AE%E3%83%86%E3%82%B9%E3%83%88%E3%81%A7%E3%81%99%E3%80%82%3C%2FSay%3E%0A%3C%2FResponse%3E&',
            })

            ret = {
              from: call.from,
              to: call.to,
              status: call.status,
              uri: 'https://api.twilio.com' + call.uri
            }
            present ret, with: API::V1::Entities::Twilio::TwilioEntity


          end
        end
      end
    end
  end
end
