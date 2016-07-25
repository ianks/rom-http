require 'rom/plugins/relation/view'
require 'rom/plugins/relation/key_inference'

module ROM
  module HTTP
    # HTTP-specific relation extensions
    #
    class Relation < ROM::Relation
      include Enumerable

      adapter :http

      use :view
      use :key_inference

      forward :with_request_method, :with_path, :append_path, :with_options,
              :with_params, :clear_params, :project

      # @api private
      def initialize(*)
        super
        if schema?
          dataset.response_transformer(
            Dataset::ResponseTransformers::Schemad.new(schema.to_h)
          )
        end
      end

      # @see Dataset#insert
      def insert(*args)
        dataset.insert(*args)
      end
      alias_method :<<, :insert

      # @see Dataset#update
      def update(*args)
        dataset.update(*args)
      end

      # @see Dataset#delete
      def delete
        dataset.delete
      end
    end
  end
end
