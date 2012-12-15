require 'active_support/concern'

module CanBe
  module ModelExtensions
    extend ActiveSupport::Concern

    module ClassMethods
      def can_be_config
        CanBe::Config.for_model self
      end

      def can_be(*types)
        if types.last.is_a?(Hash)
          options = types.last
          types.delete types.last
        end

        can_be_config.types = types
        can_be_config.parse_options options if options

        CanBe::Builder::CanBe.build(self)
      end

      def can_be_detail(can_be_model, can_be_type)
        CanBe::Config.add_detail_model self, can_be_model, can_be_type
        CanBe::Builder::CanBeDetail.build(self, can_be_model)
      end
    end
  end
end
