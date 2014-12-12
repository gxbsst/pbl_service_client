require 'pbl/base/response/extra_response'
require 'pbl/base/response/resource'

module Pbl
  module Base
    class Response

      def self.build(listener, response, verb, options = {})
        fail Pbl::Exceptions::InternalServerErrorException, '500 error', caller if response.response_code == 500
        new(listener, response, verb, options).build
      end

      attr_reader :response, :listener, :resource, :options

      def initialize(listener, response, verb = :find, options = {})
        @response = response
        @listener = listener
        @resource = Resource.new(listener, response, verb)
        @options = options
      end

      def build
        resource.build_resource
      end

    end
  end
end