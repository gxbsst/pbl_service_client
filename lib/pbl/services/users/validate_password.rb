module Pbl
  module Services
    module Users
      class ValidatePassword

        include Pbl::Helpers

        attr_accessor :email, :password

        def initialize(email, password)
          @email ||= email
          @password ||= password
        end

        def self.call(email, password)
          object = new(email, password)
          object.call
        end

        def call
          user = ::Pbl::Models::NullObject.new

          response = client.post_action(email, "authenticate", {password: password})
          data = JSON.parse(response.body, symbolize_names: true)

          user = model.new(data) if response.success?

          wrap_response(user, response)
        end

        private

        def client
          @client ||= Pbl::Clients::Client.new(model_name: 'users')
        end

        def model
          ::Pbl::Models::Users::User
        end

        def wrap_response(object, response)
          object.extend response_ext
          object.body    = response.body
          object.code    = response.response_code
          object.headers = response.headers
          object
        end

      end
    end
  end
end