require 'pbl/models/concerns/base'

module Pbl
  module Models
    module Todo
      class  TodoItem

        include Pbl::Models::Users::Base
        include ActiveModel::Validations::Callbacks
        include ActiveModel::Serializers::JSON

        class << self

          private

          def complete(id, params = {})
            response = client.custom("#{id}/actions/complete", params: query_string(params), method: :patch)
            response_class.build(self, response, :update)
          end

          def cancel_complete(id, params = {})
            response = client.custom("#{id}/actions/cancel_complete", params: query_string(params), method: :patch)
            response_class.build(self, response, :update)
          end

          def client
            @client ||= Pbl::Base::Client.new(model_name: model_origin_name.pluralize, name_space: 'todo')
          end

          def model_origin_name
            self.name.demodulize.to_s.underscore.downcase
          end
        end

      end
    end
  end
end