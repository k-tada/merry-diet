class TasksController < ApplicationController
  before_action :authenticate_user!

  # Authentication Error
  rescue_from BacklogKit::Error, with: :handle_error

  def index
    proj = merry.get_or_create_proj

    raise BacklogKit::Error, "Project not found, and cannot create new project" if proj.blank?

    @tasks = merry.get_tasks(proj.id)
                  .select {|t| t.status.name != '完了' }
                  .map {|t| Task.new(t) }
                  .map {|t| t.when = DateTime.parse(t.when).strftime('%m/%d'); t }
                  .sort {|a, b| DateTime.parse(b.when) <=> DateTime.parse(a.when)}
                  .take (3) # TODO 表示数は設定値に移動する
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.when.present? and @task.distance.present?
      proj = merry.get_or_create_proj

      raise BacklogKit::Error, "Project not found, and cannot create new project" if proj.blank?

      # 対象のプロジェクトを取得・生成出来たら関連情報を取得・生成する
      proj = merry.set_proj_infos(proj)

      merry.register_task(proj.id, {
        summary: "#{@task.when}に#{@task.distance}km歩く",
        description: @task.to_json,
        issueTypeId: proj[:issue_type].id,
        priorityId: proj[:priority].id,
        startDate: @task.get_date,
        dueDate: @task.get_date
      })

      redirect_to tasks_path
    else
      redirect_to new_task_path
    end
  end

  def show
    @task = {}
  end

  def delete
  end

  private
  def merry
    @merry ||= MerryBacklog.new(current_user.space_id, current_user.token)
  end

  def handle_error(message = nil)
    # TODO エラーハンドリング
    #      一旦認証エラー時のみログイン画面に遷移する
    if auth_error?(message)
      redirect_to '/signin', alert: "認証に失敗しました"
    else
      raise BacklogKit::Error, message
    end
  end

  def auth_error?(message)
    message.to_s.include? BacklogKit::AuthenticationError.name.demodulize
  end

  def task_params
    params.require(:task).permit(:when, :distance)
  end
end
