require 'active_record'

load File.dirname(__FILE__) + '/schema.rb'

# The Address model will use the default options
class Address < ActiveRecord::Base
  can_be :home_address, :work_address, :vacation_address
end

class Person < ActiveRecord::Base
  can_be :male, :female, field_name: :gender, default_type: :female
end
