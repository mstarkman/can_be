RSpec::Matchers.define :implement_can_be_detail do |can_be_type, details_name|
  match do |actual|
    reflections = actual.reflect_on_all_associations(:has_one)
    details_name_to_match = details_name || CanBe::Config::DEFAULT_DETAILS_NAME

    matched = false

    reflections.each do |reflection|
      as_matches = reflection.options[:as] == details_name_to_match

      if reflection.name == can_be_type.to_sym && as_matches
        matched = true
        break
      end
    end

    matched
  end

  failure_message_for_should do |actual|
    failure_message = "expected that #{actual.name} would implement can_be_detail with a can_be_type of #{can_be_type.to_sym}"
    failure_message += " and a details_name of #{details_name.to_sym}" if details_name
    failure_message += "."
    failure_message
  end
end
