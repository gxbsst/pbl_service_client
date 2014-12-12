require 'pbl/models/concerns/base'

module Pbl
  module Models
    module Skills
      class Category

        include Pbl::Models::Users::Base
        include ActiveModel::Validations::Callbacks
        include ActiveModel::Serializers::JSON

        attribute :id, String
        attribute :name, String
        attribute :position, Integer
        attribute :sub_categories, Array

        class << self

          private

          def client
            @client ||= Pbl::Base::Client.new(model_name: model_origin_name.pluralize, name_space: 'skill')
          end

          def model_origin_name
            self.name.demodulize.to_s.underscore.downcase
          end
        end
      end
    end
  end
end