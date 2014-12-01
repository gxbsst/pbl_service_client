require 'pbl/base/response/extra_response'
require 'pbl/base/response/resource'

module Pbl
  module Base
    class Response

      def self.build(listener, response, verb)
        new(listener, response, verb).build
      end

      attr_reader :response, :listener, :resource

      def initialize(listener, response, verb: :find)
        @response = response
        @listener = listener
        @resource = Resource.new(listener, response, verb)
      end

      def build
        resource.build_resource
      end

    end
  end
end