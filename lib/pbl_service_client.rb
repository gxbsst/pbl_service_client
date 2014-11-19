require "pbl_service_client/version"
require "pbl_service_client/config/configure"
require 'pbl_service_client/railtie' if defined? ::Rails::Railtie

module PblServiceClient

  #=================================
  # Configure
  #=================================
  def self.configure
    @@config ||= Config::Configure.new
  end

  def self.config
    yield self.configure
  end

end
