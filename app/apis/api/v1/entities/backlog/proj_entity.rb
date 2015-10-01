module API
  module V1
    module Entities
      module Backlog
        class ProjEntity < Grape::Entity
          expose :id
          expose :projectKey, as: :key
          expose :name
        end
      end
    end
  end
end
