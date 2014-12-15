# encoding: utf-8
# == 获取网关接口的通用类

module Pbl
  module Models
    module Users
      module Base
        extend ActiveSupport::Concern

        included do
          require "addressable/uri"
          # include Virtus.model
          include ActiveModel::Model
          extend  ActiveModel::Naming
          extend  ActiveModel::Translation
          include ActiveModel::Conversion
          include ActiveModel::Validations
          # include DynamicAttrable

          def initialize(attributes = {})
            extend(Virtus.model)
            super(attributes)
          end

          def method_missing(method, *args)
            method = method.to_s.underscore
            if method =~ /.*=$/
              attribute method.chomp('=') unless respond_to?(method)
              send(method, args[0])
            elsif respond_to?(method)
              send(method)
            else
              nil
            end
          end
        end

        def save
        end

        def assign_errors(error_data)
          return errors.add(:base, error_data[:error]) if error_data[:error].is_a? Hash
          error_data[:error].each do |attribute, attribute_errors|
            attribute_errors.each do |error|
              self.errors.add(attribute, error)
            end
          end
        end

        def persisted?
          id.present?
        end

        module ClassMethods

          #
          # ==== Examples
          #
          #  User.find(id)
          #
          def find(id, options = {})
            q = options.present? ? query_string(options) : nil
            response_class.build(self, client.get(id, q), :find)
          end

          #
          # ==== Examples
          #
          #  User.find(id)
          # == with include
          #
          # User.find(id, include: 'friends')
          def find!(id, options = {})
            q = options.present? ? query_string(options) : nil
            response = client.get(id, q)
            raise ::Pbl::Exceptions::NotFoundException.new if !response.success?
            response_class.build(self, response, :find)
          end

          #
          # ==== Examples
          #
          #  User.where(username: 'username', age: 20)
          #
          def where(parameters={})
            response = client.query(query_string(parameters))
            response_class.build(self, response, :where)
          end

          alias_method :all, :where

          def create(attributes={})
            response = client.post(envelope(attributes) )
            response_class.build(self, response, :create)
          end

          #
          # ==== Examples
          #
          #  User.create(username: 'username', age: 20)
          #  *return*
          #
          def update(id, attributes={})
            response = client.patch(id, envelope(attributes))
            response_class.build(self, response, :update)
          end

          def destroy(id)
            response_class.build(self, client.delete(id), :destroy)
          end

          #
          # ==== Examples
          #
          #  User.look_for(1, include: 'books')
          #  *return*
          #
          def look_for(id, parameters={})
            response = client.look_for(id, query_string(parameters))
            response_class.build(self, response, :find)
          end

          private

          def client
            @client ||= Pbl::Base::Client.new(model_name: model_origin_name.pluralize)
          end

          def response_class
            Pbl::Base::Response
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

        end # end ClassMethods

        module DynamicAttrable
          def initialize(attrs)
            attrs.each_pair {|k, v| send("#{k}=", v)}
            super(attrs)
          end

          def method_missing(method, *args, &block)
            method = method.to_s.underscore

            unless method =~ /.*=$/
              super
            else
              self.extend(Virtus.model)
              attribute_name = method.to_s.chomp('=')
              attribute :"#{attribute_name}", args[0].class
              send method, args[0]
            end
          end
        end

      end
    end
  end
end
