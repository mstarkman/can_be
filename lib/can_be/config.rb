module CanBe
  class Config
    DEFAULT_CAN_BE_FIELD = :can_be_type

    attr_reader :types

    def field_name
      @field_name || CanBe::Config::DEFAULT_CAN_BE_FIELD
    end

    def types=(types)
      @types = types.map(&:to_s)
    end

    def default_type
      @default_type || @types.first
    end

    def parse_options(options = {})
      @default_type = options[:default_type].to_s
      @field_name = options[:field_name]
    end

    def details
      @details ||= {}
    end

    def self.add_detail_model(klass, can_be_class, can_be_type)
      config = for_model(can_be_class)
      config.details[can_be_type] = klass.name
    end

    def self.for_model(klass)
      config_hash = @config_hash ||= {}
      hash_key = klass.is_a?(Symbol) ? klass : klass.name.underscore.to_sym

      config_hash[hash_key] = Config.new unless config_hash.has_key? hash_key
      config_hash[hash_key]
    end
  end
end
