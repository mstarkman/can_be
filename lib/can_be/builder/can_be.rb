module CanBe
  module Builder
    class CanBe
      def self.build(klass)
        new(klass).define_methods
      end

      def initialize(klass)
        @klass = klass
      end

      def define_methods
        define_processor
        define_instance_methods
        define_class_methods
        define_validations
        define_details
      end

      private
      def define_processor
        @klass.instance_eval do
          define_method :can_be_processor do
            @can_be_processor ||= Processor::Instance.new self
          end
        end

        @klass.class_eval do
          define_singleton_method :can_be_processor do
            @can_be_processor ||= Processor::Klass.new self
          end
        end
      end

      def define_instance_methods
        @klass.can_be_config.types.each do |t|
          @klass.instance_eval do
            define_method "#{t}?" do
              can_be_processor.boolean_eval(t)
            end

            define_method "change_to_#{t}" do
              can_be_processor.update_field(t)
            end

            define_method "change_to_#{t}!" do
              can_be_processor.update_field(t, true)
            end
          end
        end
      end

      def define_class_methods
        @klass.class_eval do
          define_singleton_method :find_by_can_be_types do |*types|
            can_be_processor.find_by_types(*types)
          end
        end

        @klass.can_be_config.types.each do |t|
          @klass.class_eval do
            define_singleton_method "create_#{t}" do |*args, &block|
              can_be_processor.create(t, *args, &block)
            end

            define_singleton_method "new_#{t}" do |*args, &block|
              can_be_processor.instantiate(t, *args, &block)
            end

            define_singleton_method t.pluralize.to_sym do
              can_be_processor.find_by_types t
            end

            after_initialize do |model|
              model.can_be_processor.set_default_field_value
            end
          end
        end
      end

      def define_validations
        @klass.class_eval do
          validates_inclusion_of self.can_be_config.field_name.to_sym, in: self.can_be_config.types
        end
      end

      def define_details
        @klass.class_eval do
          belongs_to :details, polymorphic: true, autosave: true

          after_initialize do |model|
            model.can_be_processor.initialize_details
          end
        end
      end
    end
  end
end
