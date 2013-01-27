require 'can_be/config'

module CanBe
  module Builder
    class CanBeDetail
      def self.build(klass, can_be_model, options = {})
        new(klass, can_be_model, options).define_functionality
      end

      def initialize(klass, can_be_model, options)
        @klass = klass
        @can_be_model = can_be_model
        @options = parse_options(options)
      end

      def define_functionality
        define_association
        define_history
      end

      def define_association
        can_be_model = @can_be_model
        details_name = @options[:details_name]

        @klass.class_eval do
          has_one can_be_model, as: details_name.to_sym, dependent: :destroy
        end
      end

      def define_history
        return unless keeps_history?

        history_model = @options[:history_model]
        details_name = @options[:details_name]
        can_be_model = @can_be_model

        @klass.instance_eval do
          define_method can_be_model do |*params|
            begin
              details = association(details_name).reader(false)
              return details
            rescue NoMethodError
              # this should be for the missing 'association_class' method because the association is broken
              # so we just want to move on and find the record manually
            end

            history_model_class = history_model.to_s.camelize.constantize
            history = history_model_class.where({
              can_be_details_id: self.id,
              can_be_details_type: self.class.name.underscore
            }).first

            can_be_model_class = can_be_model.to_s.camelize.constantize
            can_be_model_class.find(history.can_be_model_id)
          end
        end
      end

      private
      def keeps_history?
        !@options[:history_model].nil?
      end

      def parse_options(options)
        default_options = {
          details_name: Config::DEFAULT_DETAILS_NAME,
          history_model: nil
        }

        if options.is_a? Symbol
          # this is defining the details name
          default_options.merge details_name: options
        else
          # the options must be a hash
          default_options.merge options
        end
      end
    end
  end
end
