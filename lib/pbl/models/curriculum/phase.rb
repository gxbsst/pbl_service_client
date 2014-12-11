require 'pbl/models/concerns/base'

module Pbl
  module Models
    module Curriculum
      class Phase

        include Pbl::Models::Users::Base
        include ActiveModel::Validations::Callbacks
        include ActiveModel::Serializers::JSON

        attribute :id, String
        attribute :title, String
        attribute :position, Integer
        attribute :standards, Array[Pbl::Models::Curriculum::Standard]

        class << self

          private

          def client
            @client ||= Pbl::Base::Client.new(model_name: model_origin_name.pluralize, name_space: 'curriculum')
          end

          def model_origin_name
            self.name.demodulize.to_s.underscore.downcase
          end
        end

      end
    end
  end
end