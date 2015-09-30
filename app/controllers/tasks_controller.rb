class TasksController < ApplicationController
  before_action :authenticate_user!

  # Authentication Error
  rescue_from BacklogKit::Error, with: :handle_error

  def index
    @tasks = backlog.proj.all
  end

  def new
    @task = backlog.proj.create('MERRY_DIET', 'メリーさんのダイエット講座', {
      chartEnabled: false,
      subtaskingEnabled: false,
      textFormattingRule: :markdown
    })
    redirect_to task_path({id: @task['id']})
  end

  def create
  end

  def show
    @task = backlog.proj.find(params[:id])
  end

  def delete
  end

  private
  def backlog
    @backlog ||= Backlog::Tasks.new(current_user.space_id, current_user.token)
  end

  def handle_error(message = nil)
    # TODO エラーハンドリング
    #      一旦認証エラー時のみログイン画面に遷移する
    if auth_error?(message)
      redirect_to '/signin', alert: "認証に失敗しました（#{message.to_s}）"
    else
      raise BacklogKit::Error, message
    end
  end

  def auth_error?(message)
    message.to_s.include? BacklogKit::AuthenticationError.name.demodulize
  end
end
