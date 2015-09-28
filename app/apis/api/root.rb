require 'grape'

module API
  class Root < Grape::API
    # http://localhost:3000/api/
    default_format :json

    helpers do
      def logger
        API::Root.logger
      end
    end

    mount API::V1::Root

    add_swagger_documentation(
      base_path: '/',
      api_version: 'v1'
    )

    format :json
    desc 'API-DESCRIPTION'
    get '/' do
      { message: "server is running"}
    end
  end
end

