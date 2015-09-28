module API
  module V1
    class TestApi < Grape::API
      resource :test do
        desc 'GET /api/v1/test'
        get '/' do
          ret = {
            user: 'Tom',
            message: 'ok'
          }
          present ret, with: API::V1::Entities::TestEntity
        end
      end
    end
  end
end
