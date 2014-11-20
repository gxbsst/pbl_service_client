module PblServiceClient
  module Models
    module Base
      extend ActiveSupport::Concern

      included do
        require "addressable/uri"
        include Virtus.model
        extend  ActiveModel::Naming
        extend  ActiveModel::Translation
        include ActiveModel::Conversion
        include ActiveModel::Validations
      end

      def persisted?
        id.present?
      end

      def assign_errors(error_data)
        error_data[:errors].each do |attribute, attribute_errors|
          attribute_errors.each do |error|
            self.errors.add(attribute, error)
          end
        end
      end

      module ClassMethods

        def find(id)
          response = Typhoeus.get("#{base_url}/#{id}", headers: headers)
          if response.success?
            data = JSON.parse(response.body, symbolize_names: true)
            self.new(data)
          else
            nil
          end
        end

        def where(parameters={})
          parameters.reject!{ |key, value| value.blank? }
          querystring = Addressable::URI.new.tap do |uri|
            uri.query_values = parameters
          end.query

          response = Typhoeus.get("#{base_url}?#{querystring}", headers: headers)
          if response.success?
            data = JSON.parse(response.body, symbolize_names: true)
            data.map{ |record| self.new(record) }
          else
            nil
          end
        end

        alias_method :all, :where

        def create(attributes={})
          response = Typhoeus::Request.post(base_url, body: envelope(attributes), headers: headers)
          data = JSON.parse(response.body, symbolize_names: true)
          if response.success?
            object = self.new(data)
          else
            object = self.new(attributes)
            object.assign_errors(data) if response.response_code == 422
          end
          object
        end

        def update(id, attributes={})
          object = self.new(attributes.merge(id: id))
          response = Typhoeus::Request.patch("#{base_url}/#{id}", body: envelope(attributes), headers: headers)
          if response.response_code == 422
            data = JSON.parse(response.body, symbolize_names: true)
            object.assign_errors(data)
          end
          object
        end

        def destroy(id)
          response = Typhoeus::Request.delete("#{base_url}/#{id}", headers: headers)
          response.success?
        end

        private

        def envelope(attributes)
          envelope = {}
          envelope[model_origin_name] = attributes
          envelope
        end

        def base_url
          ::PblServiceClient.configure.base_url + "/" +  model_origin_name.pluralize
        end

        def model_origin_name
          self.name.demodulize.to_s.underscore.downcase
        end

        def headers
          {
            'content-type' => 'application/x-www-form-urlencoded',
            'Accept' => 'application/vnd.ibridgebrige.com; version=1'
          }
        end

      end

    end
  end
end
