module CanBe
  module Processor
    class Instance
      def initialize(model)
        @model = model
        @config = model.class.can_be_config
        @field_name = @config.field_name
      end

      def boolean_eval(t)
        field_value == t
      end

      def update_field(t, save = false)
        if save
          original_details = @model.details
          @model.update_attributes(@field_name => t)
          original_details.destroy unless original_details.class == @model.details.class
        else
          self.field_value = t
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
        set_details(field_value.to_sym) if has_details? && !@model.details_id
      end

      private
      def has_details?
        @model.respond_to?(:details) && @model.respond_to?(:details_id) && @model.respond_to?(:details_type)
      end

      def set_details(t)
        return unless has_details?

        classname = @config.details[t.to_sym]

        if classname
          @model.details = classname.constantize.new
        else
          @model.details_id = nil
          @model.details_type = nil
        end
      end
    end
  end
end

