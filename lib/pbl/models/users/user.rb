require 'pbl/models/concerns/base'

module Pbl
  module Models
    module Users
      class User

        include Base
        include ActiveModel::Validations::Callbacks
        include ActiveModel::Serializers::JSON

        attribute :id, String
        attribute :username, String
        attribute :first_name, String
        attribute :last_name, String
        attribute :age, Integer
        attribute :gender, Integer
        attribute :email, String
        attribute :extra_attributes, Hash

        validates :first_name, :last_name, presence: true

        def validate_password(email, password)
          ::Pbl::Services::Users::ValidatePassword.call(email, password)
        end

        private

        def client
          @client ||= Pbl::Client.new(model_name: model_origin_name.pluralize)
        end

        def model_origin_name
          self.name.demodulize.to_s.underscore.downcase
        end

      end
    end
  end
end