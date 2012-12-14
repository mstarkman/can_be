module CanBe
  module Processor
    class Klass
      def initialize(klass)
        @klass = klass
        @config = @klass.can_be_config
        @field_name = @config.field_name
      end

      def find_by_types(*types)
        @klass.where(@field_name => types)
      end

      def create(t, *args, &block)
        set_field_on(args, t)

        @klass.create(*args, &block)
      end

      def instantiate(t, *args, &block)
        set_field_on(args, t)

        @klass.new(*args, &block)
      end

      private
      def set_field_on(args, type)
        if args[0]
          args[0][@field_name.to_sym] = type
        else
          args[0] = { @field_name.to_sym => type }
        end
      end
    end
  end
end
