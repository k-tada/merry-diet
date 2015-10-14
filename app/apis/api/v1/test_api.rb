module API
  module V1
    class TestApi < Grape::API
      resource :test do
        desc 'GET /api/v1/test'
        params do
          requires :tel, type:String
          requires :datetime, type:DateTime
          requires :distance, type:Integer
        end
        get '/' do
          MerryTwilio.new.call_to(params[:tel], params[:datetime], params[:distance])
          {message: :ok}
        end
      end
    end
  end
end
