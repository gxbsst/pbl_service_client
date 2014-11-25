module PblServiceClient
  module Clients
    class Client
      attr_accessor :model_name

      def initialize(params = {})
        @model_name = params[:model_name]
      end

      def get(id)
        ::Typhoeus.get(resource(id), headers: headers)
      end

      def query(query_string)
        ::Typhoeus.get(resource(query_string, true), headers: headers)
      end

      def post(body)
        rest_client.post(base_url, body: body, headers: headers)
      end

      def patch(id, body)
        rest_client.patch(resource(id), body: body, headers: headers)
      end

      def delete(id)
        rest_client.delete(resource(id), headers: headers)
      end
      
      private

      def rest_client
        ::Typhoeus::Request
      end

      def base_url
        ::PblServiceClient.configure.base_url + "/" +  model_name
      end

      def headers
        {
          'content-type' => 'application/x-www-form-urlencoded',
          'Accept' => "application/vnd.ibridgebrige.com; version=#{version}"
        }
      end

      def version
        ::PblServiceClient.configure.version || 1
      end

      def resource(params, with_q = false)
        if with_q
          "#{base_url}/?#{params}"
        else
          "#{base_url}/#{params}"
        end
      end

    end
  end
end