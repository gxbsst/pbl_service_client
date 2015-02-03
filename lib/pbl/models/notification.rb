require 'pbl/models/concerns/base'

module Pbl
  module Models
    class Notification

      include Pbl::Models::Users::Base
      include ActiveModel::Validations::Callbacks
      include ActiveModel::Serializers::JSON

      class << self

        def count(params = {})
          response = client.custom("count", params: query_string(params), method: :get)
          response_class.build(self, response, :update)
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