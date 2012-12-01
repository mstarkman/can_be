module CanBe
  class Initializer
    def initialize(klass, types, options = {})
      @klass = klass
      @types = types.map(&:to_s)
      @options = parse_options(options)
    end

    def define_methods
      define_instance_methods
      define_class_methods
      define_validations
    end

    private
    def parse_options(options)
      if options.nil?
        parsed_opts = default_options
      else
        parsed_opts = default_options.merge(options)
      end

      parsed_opts[:default_type] = parsed_opts[:default_type].to_s
      parsed_opts
    end

    def default_options
      {
        field_name: :can_be_type,
        default_type: @types.first
      }
    end

    def define_instance_methods
      field_name = @options[:field_name]

      @types.each do |t|
        @klass.instance_eval do
          define_method "#{t}?" do
            send(field_name) == t
          end

          define_method "change_to_#{t}" do
            send("#{field_name}=", t)
          end

          define_method "change_to_#{t}!" do
            update_attributes(field_name => t)
          end
        end
      end
    end

    def define_class_methods
      field_name = @options[:field_name]
      default_type = @options[:default_type]

      @klass.class_eval do
        define_singleton_method :find_by_can_be_types do |*types|
          where(field_name => types)
        end
      end

      @types.each do |t|
        @klass.class_eval do
          define_singleton_method "create_#{t}" do |attributes = {}, options = {}, &block|
            attributes[field_name.to_sym] = t
            create(attributes, options, &block)
          end

          define_singleton_method "new_#{t}" do |attributes = {}, options = {}|
            attributes[field_name.to_sym] = t
            new(attributes, options)
          end

          define_singleton_method t.pluralize.to_sym do
            where(field_name => t)
          end

          after_initialize do |model|
            model.send("#{field_name}=", default_type) if model.send(field_name) == nil
          end
        end
      end
    end

    def define_validations
      field_name = @options[:field_name]
      types = @types # this is necessary for ruby scoping reasons

      @klass.class_eval do
        validates_inclusion_of field_name.to_sym, in: types
      end
    end
  end
end
