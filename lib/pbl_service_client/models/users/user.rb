require 'pbl_service_client/models/concerns/base'

module PblServiceClient
  module Models
    module Users
      class User

        include Base
        include ActiveModel::Validations::Callbacks
        extend Devise::Models

        attribute :id, String
        attribute :username, String
        attribute :first_name, String
        attribute :last_name, String
        attribute :age, Integer
        attribute :gender, Integer
        attribute :email, String
        attribute :extra_attributes, Hash

        validates :first_name, :last_name, presence: true

        devise :cas_authenticatable, :pbl_authenticatable

        def self.find_for_authentication(tainted_conditions)
          find(tainted_conditions[:username])
        end

        def validate_password(email, password)
          ::PblServiceClient::Services::Users::ValidatePassword.call(email, password)
        end

        private

        def client
          @client ||= PblServiceClient::Client.new(model_name: model_origin_name.pluralize)
        end

        def model_origin_name
          self.name.demodulize.to_s.underscore.downcase
        end

      end
    end
  end
end