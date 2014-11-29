require 'active_model'
require 'virtus'
require 'typhoeus'
require 'json'

require 'pbl/railtie' if defined? ::Rails::Railtie
require 'pbl/config'

require 'pbl/exceptions'
require 'pbl/helpers'
require 'pbl/clients'
require 'pbl/models'
require 'pbl/services'

module Pbl

  #=================================
  # Configure
  #=================================
  def self.configure
    @@config ||= Config::Configure.new(base_url: 'http://0.0.0.0:3001')
  end

  def self.config
    yield self.configure
  end
end

