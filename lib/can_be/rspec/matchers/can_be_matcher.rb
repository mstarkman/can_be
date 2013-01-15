RSpec::Matchers.define :implement_can_be do |*expected_types|
  match do |actual|
    @config = actual.can_be_config

    types_match?(expected_types || []) &&
      default_type_matches? &&
      field_name_matches? &&
      details_name_matches? &&
      details_matches?
  end

  failure_message_for_should do |actual|
    failure_message = "expected that #{actual.name} would implement can_be with the following types: #{expected_types.map(&:to_sym).join(", ")}."
    failure_message += "  With the default type of #{@expected_default_type.to_sym}." if @expected_default_type
    failure_message += "  With the field name of #{@expected_field_name.to_sym}." if @expected_field_name
    failure_message += "  With the details name of #{@expected_details_name.to_sym}." if @expected_details_name

    @expected_details.each do |can_be_type, model|
      failure_message += "  With the details of can_be_type: #{can_be_type.to_sym} & model: #{model.to_sym}."
    end if @expected_details

    failure_message
  end

  chain :with_default_type do |default_type|
    @expected_default_type = default_type
  end

  chain :with_field_name do |field_name|
    @expected_field_name = field_name
  end

  chain :with_details_name do |details_name|
    @expected_details_name = details_name
  end

  chain :and_has_details do |can_be_type, model|
    @expected_details = {} unless @expected_details
    @expected_details[can_be_type.to_sym] = model.to_sym
  end

  def types_match?(expected_types)
    return true unless expected_types
    config_types = @config.types || []
    expected_types.map(&:to_s).sort == config_types.sort
  end

  def default_type_matches?
    return true unless @expected_default_type
    @config.default_type.to_s == @expected_default_type.to_s
  end

  def field_name_matches?
    return true unless @expected_field_name
    @config.field_name.to_s == @expected_field_name.to_s
  end

  def details_name_matches?
    return true unless @expected_details_name
    @config.details_name.to_sym == @expected_details_name.to_sym
  end

  def details_matches?
    return true unless @expected_details

    @config.details.each do |can_be_type, model|
      return false unless @expected_details[can_be_type] == model
    end

    @expected_details.each do |can_be_type, model|
      return false unless @config.details[can_be_type] == model
    end

    return true
  end
end
