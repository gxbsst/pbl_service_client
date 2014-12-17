module Pbl
  module Base
    class Resource

      attr_accessor :listener, :response, :body

      def initialize(listener, response, verb)
        @listener = listener
        @response = response
        @body = JSON.parse(response.body, symbolize_names: true) rescue nil

        if verb == :create || verb == :update
          self.extend CreatingResource
        elsif verb == :find
          self.extend FindingResource
        elsif verb == :where
          self.extend WhereResource
        elsif verb == :destroy
          self.extend DestroyResource
        else
          self.class.include NormalResource
        end
      end

      def build_resource
        result =  build_model_resource.extend ExtraResponse
        wrap_response(result)
      end

      def wrap_response(result)
        result.body    = response.body
        result.code    = response.response_code
        result.headers = response.headers
        result
      end

      # def build_model_resource
      #   nil
      # end

    end

    module NormalResource
      def build_model_resource
        nil
      end
    end

    module CreatingResource
      def build_model_resource
        if response.success?
          listener.new(body)
        else
          listener.new.assign_errors(body)
        end
      end
    end

    module FindingResource
      def build_model_resource
        response.success? ? listener.new(body) : nil
      end
    end

    module WhereResource
      def build_model_resource
        if response.success?
          if !body[:data].blank?
            {
              :data => body[:data].map{ |record| listener.new(record) },
              :meta => body[:meta]
            }
          else
            {
              :data => [],
              :meta => []
            }
          end
        else
          nil
        end
      end
    end

    module DestroyResource
      def build_model_resource
        if response.success?
          listener.new(body)
        else
          nil
        end
      end
    end

  end
end
