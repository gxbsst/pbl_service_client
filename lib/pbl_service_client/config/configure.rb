module PblServiceClient
  module Config
    class Configure
      attr_accessor :base_url

      def initialize(params = {})
        @base_url ||= params[:base_url]
      end

    end
  end
end
