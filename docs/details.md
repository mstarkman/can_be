# Different Attributes per CanBe Type (details) #

CanBe can all you to store different attributes (columns) for each CanBe type that you define.  This document will show you the implementation details.

## Database Migrations ##

If you want to store different attributes (columns), there are some more columns that you will need to add to your model, `details_id` and `details_type`.  These fields will be used to store the relationships to the details information.  Indexing these columns is your choice.  Example migration:

```ruby
class AddCanBeDetailsToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :details_id, :integer
    add_column :addresses, :details_type, :string
    add_index :addresses, [:details_id, :details_type]
  end
end
```

You will also need to create the models that will be used to represent the details attributes for each type.  You will need to configure the model to be a details model be calling the `can_be_detail` method in your model.  You do not need to specify a details model for each CanBe type if there are not any extra attributes required for that type.

If you planning to use a different `details_name` for the relationship, you will need to change the names of the database columns to have the appropriate `id` and `type` columns. For example, if you wanted to use `:address_details` as the `details_name`, you would do this.

```ruby
class AddCanBeDetailsToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :address_details_id, :integer
    add_column :addresses, :address_details_type, :string
    add_index :addresses, [:address_details_id, :address_details_type]
  end
end
```

**NOTE:** Examples of the database migrations can be found in the [`spec/support/schema.rb`](../spec/support/schema.rb) file.

## Models ##

In order to wire up a model to be a CanBe details model, you will need to call the `can_be_detail` method on that model.

```ruby
class HomeAddressDetail < ActiveRecord::Base
  can_be_detail :address
end
```

The `can_be_detail` method takes in one parameter.  The parameter is the link to the CanBe model.  This must be a symbol that will reference the CanBe model.  In order to create the proper symbol, you can execute the following into your Rails console: `<ModelName>.name.underscore.to_sym`.  Here is an example: `Address.name.underscore.to_sym`.  In the above example, this will be used for the `Address` CanBe model.

You will also need to call the `add_details_model` method in the `can_be` block, passing in the CanBe type and a symbol that represets the details model class.

```ruby
class Address < ActiveRecord::Base
  can_be :home_address, :work_address, :vacation_address do
    add_details_model :home_address, :home_address_detail
  end
end
```

If you are using a different `details_name` for the relationship, you will also need to add the configuration options like this.

```ruby
class Address < ActiveRecord::Base
  can_be :home_address, :work_address, :vacation_address do
    add_details_model :home_address, :home_address_detail
    details_name :address_details
  end
end
```

```ruby
class HomeAddressDetail < ActiveRecord::Base
  can_be_detail :address, :address_details
end
```

**NOTE:** Examples of the model configurations can be found in the [`spec/support/models.rb`](../spec/support/models.rb) file.

## Accessing the Details

If you want to access the details model, you can call the `details` method on your instance and the instance of your model will be returned.  If the type of model that you are using does not have a details model, `nil` will be returned.

When you persist your CanBe model to the database, your details model will automatically be persisted.

If you are using a different `details_name`, you will access the details by calling a method of the same name.  For example, if you assigned `:address_details` to the `details_name, then you can access the details by calling the `address_details` method.

## Calling the "change_to" methods

When you are changing the type of record the details record will be changed to the correct CanBe details record.  New records will only be persisted to the database when the CanBe model is persisted.  If you change the CanBe model to a type that does not have a corresponding details model, `nil` will be stored for the details.

Changing the CanBe type with the "change_to" methods can also accept a block to allow you to set the data on the new details record.

```ruby
upload.change_to_image_upload do |details|
  details.format = "jpeg"
end
```
