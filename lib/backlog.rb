require 'backlog_kit'

class Backlog
  def initialize(space_id, token)
    raise 'No User Specified' if space_id.blank? || token.blank?
    @space_id = space_id
    @token = token
  end

  def proj
    @proj ||= Proj.new(@space_id, @token)
  end

  class Proj < Backlog
    def initialize(space_id, token)
      super(space_id, token)
    end

    def all
      client.get_projects({all: true}).body
    end

    def find(id)
      client.get_project(id).body
    end

    def create(key, name, opts = {})
      client.create_project(key, name, proj_default_opts.merge(opts)).body
    end

    def issue_types(id)
      client.get_issue_types(id).body
    end

    def add_issue_type(id, name, color)
      client.add_issue_type(id, name, color).body
    end

    def priorities
      client.get_priorities.body
    end

    private
    def proj_default_opts
      {
        chartEnabled: false,
        subtaskingEnabled: false,
        textFormattingRule: :markdown
      }
    end
  end

  def task
    @task ||= Task.new(@space_id, @token)
  end

  class Task < Backlog
    def initialize(space_id, token)
      super(space_id, token)
    end

    def all(proj_id)
      client.get_issues({:"projectId[]" => proj_id}).body
    end

    def find_by_due_date(from, to)
      client.get_issues({:"dueDateSince" => from, :"dueDateUntil" =>to}).body
    end

    def create(proj_id, params)
      client.create_issue(params.delete(:summary), params.merge({projectId: proj_id})).body
    end

    def delete(id)
      client.delete_issue(id).body
    end

    def finish(id)
      client.update_issue(id, {statusId: 4}).body
    end
  end


  protected
  def client
    @client ||= BacklogKit::Client.new(
      space_id:     @space_id,
      api_key:      nil,
      access_token: @token
    )
  end
end
