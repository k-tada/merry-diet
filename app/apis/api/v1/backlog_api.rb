module API
  module V1
    class BacklogApi < Grape::API
      # Authentication Error
      rescue_from BacklogKit::Error do |e|
        # TODO エラーハンドリング
        #      エラーの内容によってステータス変える？

        error_response(message: e.message, status: 500)
      end

      helpers do
        params :requires do
          requires :token, type: String, desc: 'Backlog Access Token'
          requires :space_id, type: String, desc: 'Backlog Space Id'
        end

        params :proj do
          requires :key, type: String, desc: 'Backlog Project key'
          requires :name, type: String, desc: 'Backlog Project name'
          optional :chartEnabled, type: Boolean, desc: 'default false'
          optional :subtaskingEnabled, type: Boolean, desc: 'default false'
          optional :textFormattingRule, type: String, desc: 'backlog or markdown(default markdown)'
          optional :projectLeaderCanEditProjectLeader, type: Boolean, desc: 'default unused'
        end

        params :proj_id do
          requires :proj_id, type: String, desc: 'Backlog Project ID'
        end

        params :task do
          requires :summary, type: String, desc: 'Backlog issue title'
          requires :description, type: String, desc: 'Backlog issue description'
          requires :issueTypeId, type: String, desc: 'Backlog issue type id'
          requires :priorityId, type: String, desc: 'Backlog priority id'
          optional :startDate, type: String, desc: 'Backlog issue start date ex. 2015-01-01'
          optional :dueDate, type: String, desc: 'Backlog issue due date ex. 2015-01-01'
        end

        def proj_default_opt
          {
            chartEnabled: false,
            subtaskingEnabled: false,
            textFormattingRule: :markdown
          }
        end

        def backlog(params)
          @backlog ||= Backlog.new(params[:space_id], params[:token])
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
            present backlog(params).proj.all, with: API::V1::Entities::Backlog::ProjEntity
          end

          desc 'POST /api/v1/backlog/proj'
          params do
            use :proj
          end
          post '/' do
            opts = proj_default_opt.merge(params.reject{|k, v| %w(space_id token).include? k})
            present backlog(params).proj.create(opts.delete('key'), opts.delete('name'), opts), with: API::V1::Entities::Backlog::ProjEntity
          end

          desc 'GET /api/v1/backlog/proj/:id'
          get '/:id' do
            present backlog(params).proj.find(params[:id]), with: API::V1::Entities::Backlog::ProjEntity
          end

          #####
          # Other API
          route_param :proj_id do
            resource :issueTypes do
              desc 'GET /api/v1/backlog/proj/:proj_id/issueTypes'
              get '/' do
                backlog(params).proj.issue_types(params[:proj_id])
              end
            end
          end
        end

        ################
        # Task API
        params do
          use :proj_id
        end
        resource :task do
          desc 'GET /api/v1/backlog/task'
          get '/' do
            backlog(params).task.all(params[:proj_id])
          end

          desc 'GET /api/v1/backlog/task/for_notification'
          params do
            optional :date, type: String, desc: 'base date ex. 2015-01-01'
          end
          get '/for_notification' do
            date = params[:date].present? ? DateTime.parse(params[:date]) : DateTime.now
            backlog(params).task.find_by_due_date(date.strftime('%Y-%m-%d'), (date + 1).strftime('%Y-%m-%d'))
          end

          desc 'POST /api/v1/backlog/task'
          params do
            use :task
          end
          post '/' do
            present backlog(params).task.create(params[:proj_id], params.reject{|k, v| %w(space_id token proj_id).include? k})
          end
        end

        ################
        # Other API
        resource :priorities do
          desc 'GET /api/v1/backlog/priorities'
          get '/' do
            backlog(params).proj.priorities
          end
        end
      end
    end
  end
end
