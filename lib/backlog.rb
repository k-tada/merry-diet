require 'backlog_kit'

module Backlog
  class Tasks
    def initialize(user)
      raise 'No User Specified' if user.blank?
      @user = user
    end

    def all
      JSON.parse client.get_projects({all: true}).body.to_json
    end

    private
    def create_client()
      @client = BacklogKit::Client.new(
        space_id:     @user.space_id,
        api_key:      nil,
        access_token: @user.token
      )
    end

    def client()
      @client || create_client
    end
  end
end
