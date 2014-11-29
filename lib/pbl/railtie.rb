# encoding: utf-8
require 'rails'

module Pbl
  class Railtie < ::Rails::Railtie

    config.pbl_service_client = ActiveSupport::OrderedOptions.new

    initializer "pbl_service_client.configure" do |app|

      Pbl.config do |config|
        config.base_url = app.config.pbl_service_client[:base_url]
        config.version = app.config.pbl_service_client[:version]
      end

    end
  end
end
