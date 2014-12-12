require 'pbl/models/concerns/base'

module Pbl
  module Models
    module Projects
      class StandardDecomposition

        include Pbl::Models::Users::Base
        include ActiveModel::Validations::Callbacks
        include ActiveModel::Serializers::JSON

        attribute :id, String
        attribute :role, String
        attribute :verb, String
        attribute :technique, String
        attribute :noun, String
        attribute :product_name, String
        attribute :product_id, String

        class << self

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