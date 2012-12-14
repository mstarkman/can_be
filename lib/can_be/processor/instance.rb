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
          @model.update_attributes(@field_name => t)
        else
          self.field_value = t
        end
      end

      def field_value=(t)
        @model.send("#{@field_name}=", t)
      end

      def field_value
        @model.send(@field_name)
      end

      def set_default_field_value
        self.field_value = @config.default_type if self.field_value.nil?
      end

      def initialize_details
        classname = @config.details[field_value.to_sym]
        @model.details = classname.constantize.new if classname && !@model.details_id
      end
    end
  end
end

