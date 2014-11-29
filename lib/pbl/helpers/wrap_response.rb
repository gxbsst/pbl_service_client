module Pbl
  module Helpers
    module WrapResponse
      def wrap_response(object, response)
        object.extend response_ext
        object.body    = response.body
        object.code    = response.response_code
        object.headers = response.headers

        object
      end

      def response_ext
        ::Pbl::Models::Response
      end
    end
  end
end