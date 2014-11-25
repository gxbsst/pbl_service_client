module PblServiceClient
  module Models
    module Response
      include Virtus.module

      attribute :code, Integer
      attribute :headers, String
      attribute :body, String

      def success?
       if /^2[0-9][0-9]$/.match(self.code.to_s)
         true
       else
         false
       end
      end

    end
  end
end