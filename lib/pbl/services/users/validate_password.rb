module Pbl
  module Services
    module Users
      class ValidatePassword

        def self.call(email, password)
          object = new(email, password)
          object.call
        end

        attr_accessor :email, :password

        def initialize(email, password)
          @email ||= email
          @password ||= password
        end

        def call
          response = client.post_action(email, 'authenticate', {password: password})
          Pbl::Base::Response.build(Pbl::Models::Users::User, response, :find)
        end

        private

        def client
          @client ||= Pbl::Base::Client.new(model_name: 'users')
        end

      end
    end
  end
end