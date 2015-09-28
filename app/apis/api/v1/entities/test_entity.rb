module API
  module V1
    module Entities
      class TestEntity < Grape::Entity
        expose :user, as: :user
        expose :message, as: :message
      end
    end
  end
end
