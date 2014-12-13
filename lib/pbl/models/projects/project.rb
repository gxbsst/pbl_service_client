require 'pbl/models/concerns/base'

module Pbl
  module Models
    module Projects
      class Project

        include Pbl::Models::Users::Base
        include ActiveModel::Validations::Callbacks
        include ActiveModel::Serializers::JSON

        attribute :id, String
        attribute :name, String
        attribute :description, String
        attribute :driven_issue, String
        attribute :standard_analysis, String
        attribute :duration, Integer
        attribute :public, Boolean
        attribute :limitation, String
        attribute :location_id, Integer
        attribute :grade_id, Integer
        attribute :rule_head, String
        attribute :rule_template, String

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