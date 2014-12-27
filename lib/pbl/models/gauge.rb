require 'pbl/models/concerns/base'

module Pbl
  module Models
      class Gauge

        include Pbl::Models::Users::Base
        include ActiveModel::Validations::Callbacks
        include ActiveModel::Serializers::JSON

        # attribute :id, String
        # attribute :level_1, String
        # attribute :level_2, String
        # attribute :level_3, String
        # attribute :level_4, String
        # attribute :level_5, String
        # attribute :level_6, String
        # attribute :level_7, String
        # attribute :technique_id, String

        class << self

          def recommends(path, params)
            response = client.custom(path, params: query_string(params))
            response_class.build(self, response, :custom)
          end

          private

          def client
            @client ||= Pbl::Base::Client.new(model_name: model_origin_name.pluralize)
          end

          def model_origin_name
            self.name.demodulize.to_s.underscore.downcase
          end
        end

      end
  end
end