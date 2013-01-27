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

          if !@config.keeps_history?
            original_details.destroy unless original_details.class == @model.send(@details_name).class
          end
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

      def save_history
        history_model_class.create({
          can_be_model_id: @model.id,
          can_be_type: field_value,
          can_be_details_id: @model.send(@details_name).id,
          can_be_details_type: details_class_name(field_value)
        }) unless history_model_for(field_value)
      end

      def destroy_history
        histories = history_model_class.where(can_be_model_id: @model.id)

        destroy_details_history(histories)
        histories.destroy_all
      end

      private
      def has_details?
        @model.respond_to?(@details_name) && @model.respond_to?(@details_id) && @model.respond_to?(@details_type)
      end

      def set_details(t)
        return unless has_details?

        if details_class_name(t)
          if @config.keeps_history?
            set_history_details_for(t)
          else
            @model.send("#{@details_name}=", details_for(t))
          end
        else
          @model.send("#{@details_id}=", nil)
          @model.send("#{@details_type}=", nil)
        end
      end

      def destroy_details_history(histories)
        histories.each do |h|
          details_record = details_class(h.can_be_type).where(id: h.can_be_details_id).first
          details_record.destroy if details_record
        end
      end

      def set_history_details_for(t)
        history_model = history_model_for(t)

        if history_model
          @model.send("#{@details_name}=", details_for(t, history_model.can_be_details_id))
        else
          @model.send("#{@details_name}=", details_for(t))
        end
      end

      def details_for(t, details_id = nil)
        if details_id.nil?
          details_class(t).new
        else
          details_class(t).find(details_id)
        end
      end

      def history_model_for(t)
        history_model_class.where(can_be_model_id: @model.id, can_be_type: t).first
      end

      def details_class_name(t)
        @config.details[t.to_sym]
      end

      def details_class(t)
        details_class_name(t).to_s.camelize.constantize if details_class_name(t)
      end

      def history_model_class
        @config.history_model.to_s.camelize.constantize
      end
    end
  end
end

