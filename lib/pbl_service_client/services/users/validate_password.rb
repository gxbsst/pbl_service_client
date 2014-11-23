module PblServiceClient
  module Services
    module Users
      module ValidatePassword
        extend ActiveSupport::Concern

        module ClassMethods

          def validate_password(email, password)
            client = PblServiceClient::Client.new(model_name: 'sessions')
            response = client.post({email: email, password: password})
            data = JSON.parse(response.body, symbolize_names: true)
            if response.success?
              object = self.new(data)
            else
              object = self.new(attributes)
              object.assign_errors(data) if response.response_code == 422
            end
            object
          end

        end
      end
    end
  end
end