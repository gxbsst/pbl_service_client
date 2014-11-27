require 'pbl_service_client/models/response'
require 'pbl_service_client/models/null_object'
require 'pbl_service_client/models/users/user'


# alias namespace
module Pbl
  module Models
    module Users
      User = ::PblServiceClient::Models::Users::User
    end
  end
end
