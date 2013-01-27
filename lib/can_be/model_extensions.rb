require 'active_support/concern'

module CanBe
  module ModelExtensions
    extend ActiveSupport::Concern

    module ClassMethods
      def can_be_config
        @can_be_config ||= CanBe::Config.new
      end

      def can_be(*types, &block)
        if types.last.is_a?(Hash)
          options = types.last
          types.delete types.last
        end

        can_be_config.types = types
        can_be_config.parse_options options if options

        can_be_config.instance_eval(&block) if block_given?

        CanBe::Builder::CanBe.build(self)
      end

      def can_be_detail(can_be_model, options = {})
        CanBe::Builder::CanBeDetail.build(self, can_be_model, options)
      end
    end
  end
end
