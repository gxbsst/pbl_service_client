require 'pbl/models/concerns/base'

module Pbl
  module Models
    module Projects
      class Technique

        include Pbl::Models::Users::Base
        include ActiveModel::Validations::Callbacks
        include ActiveModel::Serializers::JSON

        # attribute :id, String
        # attribute :project_id, String
        # attribute :technique_id, String

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