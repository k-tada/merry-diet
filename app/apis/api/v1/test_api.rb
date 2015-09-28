module API
  module V1
    class TestApi < Grape::API
      resource :test do
        desc 'GET /api/v1/test'
        get '/' do
          {message: :ok}
        end
      end
    end
  end
end
