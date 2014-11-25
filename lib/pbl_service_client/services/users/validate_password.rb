module PblServiceClient
  module Services
    module Users
      class ValidatePassword

        include PblServiceClient::Helpers

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
          user = ::PblServiceClient::Models::NullObject.new

          response = client.post({login: email, password: password})
          data = JSON.parse(response.body, symbolize_names: true)

          user = model.new(data) if response.success?

          wrap_response(user, response)
        end

        private

        def client
          @client ||= PblServiceClient::Client.new(model_name: 'sessions')
        end

        def model
          ::PblServiceClient::Models::Users::User
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