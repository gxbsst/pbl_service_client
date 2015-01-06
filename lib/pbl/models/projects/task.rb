require 'pbl/models/concerns/base'

module Pbl
  module Models
    module Projects
      class Task

        include Pbl::Models::Users::Base
        include ActiveModel::Validations::Callbacks
        include ActiveModel::Serializers::JSON

        class << self

          def release(id, params = {})
            response = client.custom("#{id}/actions/release", params: query_string(params), method: :patch)
            response_class.build(self, response, :update)
          end

          private

          def client
            @client ||= Pbl::Base::Client.new(model_name: model_origin_name.pluralize, name_space: 'pbl')
          end

          def model_origin_name
            self.name.demodulize.to_s.underscore.downcase
          end
        end

      end
    end
  end
end