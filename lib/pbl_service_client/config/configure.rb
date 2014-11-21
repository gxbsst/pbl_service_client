module PblServiceClient
  module Config
    class Configure
      attr_accessor :base_url, :version

      def initialize(params = {})
        @base_url ||= params[:base_url]
        @version ||= params[:version]
      end

    end
  end
end
