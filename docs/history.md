# Keeping Details History When Changing CanBe Types #

CanBe provides a history facility that will allow the [details](details.md) data to be preserved when switching between CanBe types.  This way if you switch back to a CanBe type that was previously used, the specific data for the new CanBe type will still be available.

## Database Migrations ##

To implement this history facility, there are no modifications necessary to your existing CanBe tables.  You will only need to create a table (via migration) that will store the references for the CanBe types.  All of the attribute (column) names **must** be named as shown in the example below.

``` ruby
create_table :address_can_be_histories, :force => true do |t|
  t.integer :can_be_model_id
  t.string :can_be_type
  t.integer :can_be_details_id
  t.string :can_be_details_type
  t.timestamps
end
```

**NOTE:** Examples of the database migrations can be found in the [`spec/support/schema.rb`](../spec/support/schema.rb) file.

## Models ##

There are only a few changes that are required to wire up the history model to the CanBe and CanBe details models.

First, you must create an Active Record model for the history table.

``` ruby
class AddressHistory < ActiveRecord::Base
end
```

### CanBe Model ###

You will have to tell your current CanBe model to use the history model that you defined by adding a call to the `#keep_history_in` method.

```ruby
class Address < ActiveRecord::Base
  can_be :home_address, :work_address, :vacation_address do
    add_details_model :home_address, :home_address_detail
    keep_history_in :address_history
  end
end
```

### CanBe Details Models ###

For each of the details models, you will also have to pass in the history model when calling the `#can_be_detail` method.

```ruby
class HomeAddressDetail < ActiveRecord::Base
  can_be_detail :address, history_model: :address_history
end
```

**NOTE:** If you also want to change the `details_name` for the CanBe model, you will also need to specify that in the `options` parameter of the `#can_be_detail` method call.

```ruby
class HomeAddressDetail < ActiveRecord::Base
  can_be_detail :address, history_model: :address_history, details_name: :address_details
end
```

## Calling the "change_to" methods ##

When you are not storing history for a CanBe model and you call a "change_to" method, the details record that is no longer active will be destroyed.  However, when you are storing the history, that record will *not* be destroy by default.

The "change_to" methods can now take in a parameter that, when set to `true`, will destroy the details record that is no longer active.

## Access the CanBe model from an inactive details model ##

You can access the CanBe model from any details model that is in the database.  This is done in the same way as accessing it from the active details model.
