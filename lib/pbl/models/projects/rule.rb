require 'pbl/models/concerns/base'

module Pbl
  module Models
    module Projects
      class  Rule

        include Pbl::Models::Users::Base
        include ActiveModel::Validations::Callbacks
        include ActiveModel::Serializers::JSON

        attribute :id, String
        attribute :weight, String
        attribute :level_1, String
        attribute :level_2, String
        attribute :level_3, String
        attribute :level_4, String
        attribute :level_5, String
        attribute :project_id, String
        attribute :technique_id, String
        attribute :gauge_id, String
        attribute :standard, String

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