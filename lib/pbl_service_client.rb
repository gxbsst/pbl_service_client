require 'active_support/core_ext/hash/indifferent_access'
require 'active_model'
require 'virtus'
require 'rest-client'
require 'typhoeus'

require 'pbl_service_client/version'
require 'pbl_service_client/config/configure'
require 'pbl_service_client/railtie' if defined? ::Rails::Railtie
require 'pbl_service_client/models/concerns/base'
require 'pbl_service_client/models/user'

module PblServiceClient

  #=================================
  # Configure
  #=================================
  def self.configure
    @@config ||= Config::Configure.new(base_url: 'http://localhost:3000')
  end

  def self.config
    yield self.configure
  end

end
