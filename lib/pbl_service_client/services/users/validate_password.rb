module PblServiceClient
  module Services
    module Users
      class ValidatePassword

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
          response = client.post({email: email, password: password})
          data = JSON.parse(response.body, symbolize_names: true)
          if response.success?
            object = model.new(data)
          else
            object = model.new(attributes)
            object.assign_errors(data) if response.response_code == 422
          end
          object
        end

        private

        def client
          @client ||= PblServiceClient::Client.new(model_name: 'sessions')
        end

        def model
          ::PblServiceClient::Models::Users::User
        end

      end
    end
  end
end