module Pbl
  module Base
    class Client
      attr_accessor :model_name, :name_space

      def initialize(params = {})
        @model_name = params[:model_name]
        @name_space = params.fetch(:name_space, nil)
      end

      def get(id, query_string = nil)
        if query_string
          resource = resource_with_query(id, query_string)
        else
          resource = resource(id)
        end

        ::Typhoeus.get(resource, headers: headers)
      end

      def query(query_string)
        ::Typhoeus.get(resource(query_string, true), headers: headers)
      end

      # def look_for(id, query_string)
      #   ::Typhoeus.get(full_url(id, query_string), headers: headers)
      # end

      def post(body)
        rest_client.post(base_url, body: body, headers: headers)
      end

      def patch(id, body)
        rest_client.patch(resource(id), body: body, headers: headers)
      end

      def delete(id)
        rest_client.delete(resource(id), headers: headers)
      end

      def post_action(id, action, body)
        url = "#{base_url}/#{id}/actions/#{action}"
        rest_client.post(url, body: body, headers: headers)
      end
      
      private

      def rest_client
        ::Typhoeus::Request
      end

      def base_url
        if name_space.present?
          ::Pbl.configure.base_url + "/#{name_space}" + "/" +  model_name
        else
          ::Pbl.configure.base_url + "/" + model_name
        end
      end

      def headers
        {
          # 'content-type' => 'application/x-www-form-urlencoded',
          'Accept' => "application/vnd.ibridgebrige.com; version=1"
        }
      end

      def version
        ::Pbl.configure.version || 1
      end

      def resource(params, with_q = false)
        if with_q
          "#{base_url}/?#{params}"
        else
          "#{base_url}/#{params}"
        end
      end

      def resource_with_query(params, query_string)
        "#{base_url}/#{params}?#{query_string}"
      end

      # def full_url(id, params)
      #   "#{base_url}/#{id}?#{params}"
      # end

    end
  end
end