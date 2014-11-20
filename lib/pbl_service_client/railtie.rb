# encoding: utf-8
require 'rails'

module PblServiceClient
  class Railtie < ::Rails::Railtie

    config.pbl_service_client = ActiveSupport::OrderedOptions.new

    initializer "pbl_service_client.configure" do |app|

      PblServiceClient.config do |config|
        config.base_url = app.config.pbl_service_client[:base_url]
      end

    end
  end
end
