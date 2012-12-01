require 'active_support/concern'

module CanBe
  module ModelExtensions
    extend ActiveSupport::Concern

    module ClassMethods
      def can_be(*types)
        if types.last.is_a?(Hash)
          options = types.last
          types.delete types.last
        end

        CanBe::Initializer.new(self, types, options).define_methods
      end
    end
  end
end
