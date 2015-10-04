module API
  module V1
    module Entities
      module Twilio
        class TwilioEntity < Grape::Entity
          expose :from, as: :from
          expose :to, as: :to
          expose :status, as: :status
          expose :uri, as: :uri
        end
      end
    end
  end
end
