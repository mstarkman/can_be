module CanBe
  module Builder
    class CanBeDetail
      def self.build(klass, can_be_model)
        new(klass, can_be_model).define_association
      end

      def initialize(klass, can_be_model)
        @klass = klass
        @can_be_model = can_be_model
      end

      def define_association
        can_be_model = @can_be_model

        @klass.class_eval do
          has_one can_be_model, as: :details
        end
      end
    end
  end
end
