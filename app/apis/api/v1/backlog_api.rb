module API
  module V1
    class BacklogApi < Grape::API
      # Authentication Error
      rescue_from BacklogKit::Error, with: :handle_error

      helpers do
        params :requires do
          requires :token, type: String, desc: 'Backlog Access Token'
          requires :space_id, type: String, desc: 'Backlog Space Id'
        end

        def backlog(params)
          @backlog ||= Backlog::Tasks.new(params[:space_id], params[:token])
        end
      end

      params do
        use :requires
      end

      # TODO: ファイル分けられるなら分ける
      resource :backlog do

        ################
        # Proj API
        resource :proj do
          desc 'GET /api/v1/backlog/proj'
          get '/' do
            backlog(params).proj.all
          end
        end
      end

      def handle_error(message = nil)
        # TODO エラーハンドリング
        #      一旦認証エラー時のみログイン画面に遷移する
        # if auth_error?(message)
        #   redirect_to '/signin', alert: "認証に失敗しました（#{message.to_s}）"
        # else
        #   raise BacklogKit::Error, message
        # end

        error_response(message: message, status: 500)
      end
    end
  end
end
