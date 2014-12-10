require 'pbl/models/concerns/base'

Devise::Models::CASAuthenticatable = Devise::Models::CasAuthenticatable

module Pbl
  module Models
    module Users
      class User

        extend Devise::Models

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
        attribute :password_digest, String
        attribute :extra_attributes, Hash

        devise :cas_authenticatable, :pbl_authenticatable

        validates :first_name, :last_name, presence: true

        def self.find_for_authentication(tainted_conditions)
          find(tainted_conditions[:username])
        end

        def validate_password(email, password)
          ::Pbl::Services::Users::ValidatePassword.call(email, password)
        end


        # private
        #
        # def client
        #   @client ||= Pbl::Client.new(model_name: model_origin_name.pluralize)
        # end
        #
        # def model_origin_name
        #   self.name.demodulize.to_s.underscore.downcase
        # end

      end
    end
  end
end