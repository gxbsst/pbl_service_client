require 'active_model'
require 'virtus'
require 'typhoeus'
require 'json'

require 'pbl_service_client/version'
require 'pbl_service_client/railtie' if defined? ::Rails::Railtie
require 'pbl_service_client/config'

require 'pbl_service_client/clients'

require 'pbl_service_client/services'

require 'pbl_service_client/models'


module PblServiceClient

  #=================================
  # Configure
  #=================================
  def self.configure
    @@config ||= Config::Configure.new(base_url: 'http://0.0.0.0:3000')
  end

  def self.config
    yield self.configure
  end

end
