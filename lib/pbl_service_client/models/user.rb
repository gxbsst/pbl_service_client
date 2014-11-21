require 'pbl_service_client/models/concerns/base'

module PblServiceClient
  module Models
    class User

      include Base

      attribute :id, String
      attribute :first_name, String
      attribute :last_name, String
      attribute :age, Integer
      attribute :gender, Integer

      validates :first_name, :last_name, presence: true

      # def save
      #   return false unless valid?
      #
      #   request =  ''
      #
      #   if response.code == 200
      #     self
      #   else
      #     errors.add(:http_code, response.code)
      #     errors.add(:http_response_body, response.body)
      #     nil
      #   end
      # end

    end
  end
end