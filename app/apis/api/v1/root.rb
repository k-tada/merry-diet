module API
  module V1
    class Root < Grape::API
      # http://localhost:3000/api/v1/
      prefix :api
      version 'v1', using: :path

      format :json
      default_format :json

      mount API::V1::TestApi
      mount API::V1::BacklogApi
      mount API::V1::TwilioApi
    end
  end
end

