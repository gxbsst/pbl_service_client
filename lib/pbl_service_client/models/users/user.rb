require 'pbl_service_client/models/concerns/base'

module PblServiceClient
  module Models
    module Users
      class User

        include Base

        include ::PblServiceClient::Services::Users::ValidatePassword

        attribute :id, String
        attribute :first_name, String
        attribute :last_name, String
        attribute :age, Integer
        attribute :gender, Integer
        attribute :email, String

        validates :first_name, :last_name, presence: true

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