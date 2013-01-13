require 'can_be/config'

module CanBe
  module Builder
    class CanBeDetail
      def self.build(klass, can_be_model, details_name = nil)
        new(klass, can_be_model, details_name).define_association
      end

      def initialize(klass, can_be_model, details_name)
        @klass = klass
        @can_be_model = can_be_model
        @details_name = details_name || Config::DEFAULT_DETAILS_NAME
      end

      def define_association
        can_be_model = @can_be_model
        details_name = @details_name

        @klass.class_eval do
          has_one can_be_model, as: details_name.to_sym, dependent: :destroy
        end
      end
    end
  end
end
