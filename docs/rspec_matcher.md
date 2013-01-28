# Custom RSpec Matchers

Included in this gem are a set of matchers for RSpec that can be used to ensure the `can_be` and `can_be_detail` configuration in your models.  To use these matchers, you will need to include this line in your `spec_helper.rb` file.

`require 'can_be/rspec/matchers'`

You can then use the `implement_can_be` matcher as follows.  There are a number of fluent methods that you can use as well.  These methods can be seen in the [`spec/can_be/rspec/matchers/can_be_matcher_spec.rb`](https://github.com/mstarkman/can_be/blob/master/spec/can_be/rspec/matchers/can_be_matcher_spec.rb) file.

`Address.should implement_can_be(:home_address, :work_address, :vacation_address)`

Examples of the `implement_can_be_detail` matcher can be found in the [`spec/can_be/rspec/matchers/can_be_detail_matcher_spec.rb`](https://github.com/mstarkman/can_be/blob/master/spec/can_be/rspec/matchers/can_be_detail_matcher_spec.rb) file.