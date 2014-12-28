module Pbl
  module Base
    module ExtraResponse
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

      def data
       self.fetch(:data)
      end

      def meta
        self.fetch(:meta)
      end

      def id
        self.fetch(:id)
      end

    end
  end
end
