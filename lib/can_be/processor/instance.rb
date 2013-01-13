module CanBe
  module Processor
    class Instance
      def initialize(model)
        @model = model
        @config = model.class.can_be_config
        @field_name = @config.field_name
        @details_name = @config.details_name.to_sym
        @details_id = "#{@details_name}_id".to_sym
        @details_type = "#{@details_name}_type".to_sym
      end

      def boolean_eval(t)
        field_value.to_s == t.to_s
      end

      def update_field(t, save = false)
        if save
          original_details = @model.send(@details_name)
          @model.update_attributes(@field_name => t)
          original_details.destroy unless original_details.class == @model.send(@details_name).class
        else
          self.field_value = t
        end

        if block_given?
          yield(@model.send(@details_name))
          @model.send(@details_name).save if save
        end
      end

      def field_value=(t)
        set_details(t)
        @model.send(:write_attribute, @field_name, t)
      end

      def field_value
        @model.read_attribute(@field_name)
      end

      def set_default_field_value
        self.field_value = @config.default_type if self.field_value.nil?
      end

      def initialize_details
        set_details(field_value.to_sym) if has_details? && !@model.send(@details_id)
      end

      private
      def has_details?
        @model.respond_to?(@details_name) && @model.respond_to?(@details_id) && @model.respond_to?(@details_type)
      end

      def set_details(t)
        return unless has_details?

        classname = @config.details[t.to_sym]

        if classname
          @model.send("#{@details_name}=", classname.to_s.camelize.constantize.new)
        else
          @model.send("#{@details_id}=", nil)
          @model.send("#{@details_type}=", nil)
        end
      end
    end
  end
end

