module Devise
  module Models
    module PblAuthenticatable
      # extend ActiveSupport::Concern

      module ClassMethods
        def serialize_from_session(key, salt)
          resource = Pbl::Models::Users::User.find(key)
          resource if resource && salt == resource.authenticatable_salt
        end

        def serialize_into_session(resource)
          [resource.username, resource.authenticatable_salt]
        end
      end

      def authenticatable_salt
        password_digest[0,29] if password_digest
      end
    end
  end
end

Devise.add_module :pbl_authenticatable, :controller => :sessions
