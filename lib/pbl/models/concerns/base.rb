module Pbl
  module Models
    module Users
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

        def save
        end

        def persisted?
          id.present?
        end

        def assign_errors(error_data)
          return errors.add(:base, error_data[:error]) if error_data[:error].is_a? Hash
          error_data[:error].each do |attribute, attribute_errors|
            attribute_errors.each do |error|
              self.errors.add(attribute, error)
            end
          end
        end

        module ClassMethods

          def find(id)
            Pbl::Base::Response.build(self, client.get(id), verb: :find)
          end

          def find!(id)
            response = client.get(id)
            raise ::Pbl::Exceptions::NotFoundException.new if !response.success?
            Pbl::Base::Response.build(self, response, verb: :find)
          end

          def where(parameters={})
            response = client.query(query_string(parameters))
            Pbl::Base::Response.build(self, response, verb: :where)
          end

          alias_method :all, :where

          def create(attributes={})
            response = client.post(envelope(attributes) )
            Pbl::Base::Response.build(self, response, verb: :create)
          end

          def update(id, attributes={})
            response = client.patch(id, envelope(attributes))
            Pbl::Base::Response.build(self, response, verb: :update)
          end

          def destroy(id)
            Pbl::Base::Response.build(self, client.delete(id), verb: :destroy)
          end

          private

          def client
            @client ||= Pbl::Base::Client.new(model_name: model_origin_name.pluralize)
          end

          def envelope(attributes)
            envelope = {}
            envelope[model_origin_name] = attributes
            envelope
          end

          def model_origin_name
            self.name.demodulize.to_s.underscore.downcase
          end

          def query_string(parameters)
            parameters.reject!{ |key, value| value.blank? }

            Addressable::URI.new.tap do |uri|
              uri.query_values = parameters
            end.query
          end

        end

      end
    end
  end
end
