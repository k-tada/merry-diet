require 'backlog_kit'

module Backlog
  class Tasks
    def initialize(space_id, token)
      raise 'No User Specified' if space_id.blank? || token.blank?
      @space_id = space_id
      @token = token
    end

    def proj
      @proj ||= Proj.new(@space_id, @token)
    end

    class Proj < Tasks
      def initialize(space_id, token)
        super(space_id, token)
      end

      def all
        client.get_projects({all: true}).body
      end

      def find(id)
        client.get_project(id).body
      end

      def create(key, name, opts)
        client.create_project(key, name, opts).body
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
end

module BacklogKit
  class Response
    def process(raw)
      case raw
      when Hash then raw.to_h
      when Array then raw.map{|r| r.to_h}
      else raw
      end
    end
  end
end
