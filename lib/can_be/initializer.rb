module CanBe
  class Initializer
    def initialize(klass, types, options = {})
      @klass = klass
      @types = types
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
        default_options
      else
        default_options.merge(options)
      end
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

      @types.each do |t|
        @klass.class_eval <<-EVAL
          def self.create_#{t}(attributes = {}, options = {}, &block)
            attributes[:#{field_name}] = '#{t}'
            create(attributes, options, &block)
          end

          def self.new_#{t}(attributes = {}, options = {})
            attributes[:#{field_name}] = '#{t}'
            new(attributes, options)
          end

          def self.find_by_can_be_types(*types)
            where(#{field_name}: types)
          end

          def self.#{t.pluralize}
            where(#{field_name}: '#{t}')
          end

          after_initialize do |model|
            model.#{field_name} = '#{default_type}' if model.#{field_name}.nil?
          end
        EVAL
      end
    end

    def define_validations
      field_name = @options[:field_name]

      @klass.class_eval <<-EVAL
        validates_inclusion_of :#{field_name}, in: ['#{@types.join(',').gsub(/,/, "', '")}']
      EVAL
    end
  end
end
