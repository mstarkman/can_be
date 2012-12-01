# CanBe [![Build Status](https://secure.travis-ci.org/mstarkman/can_be.png?branch=master)](https://travis-ci.org/mstarkman/can_be) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/mstarkman/can_be)

Adds helper methods to your Active Record models to control the type of record.

## Installation

Add this line to your application's Gemfile:

    gem 'can_be'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install can_be

## Usage

Before adding it to your model, you will need to add a database field to
your model.  By default, the `can_be` gem expects your field to be
called `can_be_type`.  However, this can be changed.

```ruby
class AddCanBeTypeToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :can_be_type, :string
    add_index :addresses, :can_be_type
  end
end
```

Once you've installed the gem, you will have access to the `can_be` method in your models.  The `can_be` method will take a list of types (as symbols) that your model can be represented as.

```ruby
class Address < ActiveRecord::Base
  can_be :home_address, :work_address, :vacation_address
end
```

### Methods Added to your model

The following methods will then be added to your model for each of the types based on the example above.

#### Class Methods

* `create_home_address` - Creates a new address model in the database with the type of `home_address`
* `find_by_can_be_types` - Accepts a list of types and returns the results of the database query (note: this is only added once, not for each type)
* `home_addresses` - Returns a list of the records with a type of `home_address`
* `new_home_address` - Instantiates a new address model instance with the type of `home_address`

#### Instance Methods

* `change_to_home_address` - Changes the record to a `home_address` type (does not save it to the database)
* `change_to_home_address!` - Changes the record to a `home_address` type and saves it to the database
* `home_address?` - Returns true if the record is a `home_address` type

### Options

The following options can be added to the `can_be` method call.

* `default_type` - Sets the default value for when a new record is instantiated (it is the first value in the list by default)
* `field_name` - Sets the ActiveRecord field name that is to be used (by default it expects a `can_be_type` field to be present)

Here is an example.

```ruby
class Person < ActiveRecord::Base
  can_be :male, :female, field_name: :gender, default_type: :female
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

See [LICENSE.txt](https://github.com/mstarkman/can_be/blob/master/LICENSE.txt).
