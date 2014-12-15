require 'pbl/models/concerns/base'

module Pbl
  module Models
    module Skills
      class Technique

        include Pbl::Models::Users::Base
        include ActiveModel::Validations::Callbacks
        include ActiveModel::Serializers::JSON

        # attribute :id, String
        # attribute :title, String
        # attribute :position, Integer
        # attribute :sub_category_id, String
        # attribute :techniques, Array
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