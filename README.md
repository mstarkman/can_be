# CanBe [![Build Status](https://secure.travis-ci.org/mstarkman/can_be.png?branch=master)](https://travis-ci.org/mstarkman/can_be) [![Gem Version](https://badge.fury.io/rb/can_be.png)](http://badge.fury.io/rb/can_be) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/mstarkman/can_be)

CanBe allows you to track the type of your ActiveRecord model in a consistent simple manner.  With just a little configuration on your part, each type of record can contain different attributes that are specifc to that type of record.  From a data modelling perspective this is preferred over [ActiveRecord STI](http://api.rubyonrails.org/classes/ActiveRecord/Base.html#label-Single+table+inheritance) since you will not have many columns in your database that have null values.  Under the hood, CanBe uses one-to-one [Polymorphic Associations](http://guides.rubyonrails.org/association_basics.html#polymorphic-associations) to accomplish the different attributes per type.

## Installation

Add this line to your application's Gemfile:

    gem 'can_be'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install can_be

## Database Configuration (via migrations)

In its simplest form, you only need to add a string attribute (column) to the model can be different types.  By default, this attribute must be named `can_be_type`.  However, you can have the attribute be named anything that you would like, you just need to tell CanBe what it is.  Indexing this column is your choice.

Example migration:

```ruby
class AddCanBeTypeToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :can_be_type, :string
    add_index :addresses, :can_be_type
  end
end
```

### Details Configuration

If you want to store different attributes (columns), there are some more columns that you will need to add to your model, `details_id` and `details_type`.  These fields will be used to store the relationships to the details information.  Indexing these columns is your choice.

Example migration:

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

## Model Configuration

To add CanBe to your model, you simply need to call the `can_be` method
on your model.

```ruby
class Address < ActiveRecord::Base
  can_be :home_address, :work_address, :vacation_address
end
```

The `can_be` method will take in a list of valid types that will be used by CanBe.  There is an optional last parameter that is a hash of the options.  This is a list of valid options.

* `:default_type` - Sets the default value for when a new record is instantiated or created (it is the first value in the list by default)
* `:field_name` - Sets the ActiveRecord field name that is to be used (if not specified, CanBe expects a `can_be_type` attribute to be present)

Here is an example of the options.

```ruby
class Person < ActiveRecord::Base
  can_be :male, :female, field_name: :gender, default_type: :female
end
```

Or you can set the options in a block when calling `can_be`.

```ruby
class Person < ActiveRecord::Base
  can_be :male, :female do
    field_name :gender
    default_type :female
  end
end
```

### Details Model Configuration

In order to wire up a model to be a CanBe details model, you will need to call the `can_be_detail` method on that model.

```ruby
class HomeAddressDetail < ActiveRecord::Base
  can_be_detail :address
end
```
The `can_be_detail` method take in one parameter.  The parameter is the link to the CanBe model.  This must be a symbol that will reference the CanBe model.  In order to create the proper symbol, you can execute the following into your Rails console: `<ModelName>.name.underscore.to_sym`.  Here is an example: `Address.name.underscore.to_sym`.  In the above example, this will be used for the `Address` CanBe model.

You will also need to call the `add_details_model` method in the `can_be` block, passing in the CanBe type and a symbol that represets the details model class.

```ruby
class Address < ActiveRecord::Base
  can_be :home_address, :work_address, :vacation_address do
    add_details_model :home_address, :home_address_detail
  end
end
```

## Usage

The CanBe gem will provide you a lot methods to handle your type processing in an easy and consistent manner.

### Instantiating New Models

You can continue to instantiate your CanBe models by using the `new` method.  When you do, CanBe will ensure that the type of the record is assigned the detault CanBe type for your model.

There are also some helper methods put on your model to make it easier to instantiate the type of model that you want.  These methods will take the form of `new_<CanBe type>`.  For example, you can call `Address.new_home_address`.  These methods will take the same parameters as the base `new` method provided by ActiveRecord.

### Creating New Models

You can continue to create your CanBe models by using the `create` method.  When you do, CanBe will ensure that the type of the record is assigned the detault CanBe type for your model.

There are also some helper methods put on your model to make it easier to create the type of model that you want.  These methods will take the form of `create_<CanBe type>`.  For example, you can call `Address.create_home_address`.  These methods will take the same parameters as the base `create` method provided by ActiveRecord.

### Changing CanBe Types

There are several ways to change the type of record that you are working with.  You can access the `can_be_type` attribute (or other attribute if you specified the field to be used) and change the value directly.

There are also instance methods provided on your model that allow for changing to a specific CanBe type.

You can change the type of record and not persist it immediately to the database by calling the appropriate `change_to_<CanBe type>` method.  For example, you can call `Address.new.change_to_work_address` method to change the record to be of CanBe type `:work_address`.

If you want to change the type of the record and persist it to the database immediately, you can call the appropriate `change_to_<CanBe type>!` method.  For example, this method call will change the type of record to `:work_address` and persist the change to the database: `Address.create.change_to_work_address!`

There is a validator for the CanBe field, that will unsure that the CanBe field is set to one of the CanBe types before persisting the record. 

When changing the type of the record via either of these methods, you can pass in a block that will provide you access to the new details record so you can set any data in one method call.

```ruby
upload.change_to_image_upload do |details|
  details.format = "jpeg"
end
```

NOTE: that when you are changing the type of record the details record will be changed to the correct CanBe details record.  New records will only be persisted to the database when the CanBe model is persisted.  If you change the CanBe model to a type that does not have a corresponding details model, `nil` will be stored for the details.

### Boolean Evaluation

With CanBe, it is easy to determine the type of record that you are working with.  This is accomplished by calling the `<CanBe type>?` on the instance of your model.  For example if you wanted to see if the `Address` instance you are working with, you would call `Address.first.home_address?` and it would return `true` or `false` depending on the CanBe type of the record.

### Finding Records

There are two ways to find specific types of records.  You can use the `find_by_can_be_types` method, which takes in a list of the CanBe types that you want to find.  For example, if you wanted to find all of the home and work addresses you would call `Address.find_by_can_be_types :home_address, :work_address`.

Methods are also defined on your CanBe model that will find all of the records for a specific CanBe type.  These methods take the form of `<pluralized CanBe type>`.  For example, `Address.home_addresses` would return all of the records with a type of `:home_address`.

### Accessing the Details

If you want to access the details model, you can call the `details` method on your instance and the instance of your model will be returned.  If the type of model that you are using does not have a details model, `nil` will be returned.

When you persist your CanBe model to the database, your details model will automatically be persisted.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
    * Make sure to include the appropriate specs
    * Specs can be run by executing the `rake` command in the terminal
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

See [LICENSE.txt](https://github.com/mstarkman/can_be/blob/master/LICENSE.txt).
