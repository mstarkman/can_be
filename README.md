# CanBe [![Build Status](https://secure.travis-ci.org/mstarkman/can_be.png?branch=master)](https://travis-ci.org/mstarkman/can_be) [![Gem Version](https://badge.fury.io/rb/can_be.png)](http://badge.fury.io/rb/can_be) [![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/mstarkman/can_be)

CanBe allows you to track the type of your ActiveRecord model in a consistent simple manner.  With just a little configuration on your part, each type of record can contain different attributes that are specific to that type of record.  From a data modeling perspective this is preferred over [ActiveRecord STI](http://api.rubyonrails.org/classes/ActiveRecord/Base.html#label-Single+table+inheritance) since you will not have many columns in your database that have null values.  Under the hood, CanBe uses one-to-one [Polymorphic Associations](http://guides.rubyonrails.org/association_basics.html#polymorphic-associations) to accomplish the different attributes per type.

Here is a blog post that will describe more of the rationale behind the CanBe gem: [http://blog.markstarkman.com/blog/2013/01/09/writing-my-first-rubygem-canbe/](http://blog.markstarkman.com/blog/2013/01/09/writing-my-first-rubygem-canbe/)

## Versioning

I will be following [Semantic Versioning](http://semver.org/) as closely as possible.  The `master` branch will be the latest development version and may not match the version of the code you are using. There is a git tag for each released version.  The [CHANGELOG.md](CHANGELOG.md) will contain the correct links to each version.

## Installation

Add this line to your application's Gemfile:

    gem 'can_be'

If you feel like living on the edge, you can add this to your applications' Gemfile:

    gem 'can_be', git: "git://github.com/mstarkman/can_be.git"

And then execute:

    $ bundle

## Documentation 

The documentation for the basic implementation of CanBe can be found in this readme.  Here is the documentation for the other features.

* [Different Attributes per CanBe Type (details)](docs/details.md)
* [Keeping Details History When Changing CanBe Types](docs/history.md)
* [Custom RSpec Matchers](docs/rspec_matcher.md)

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

**NOTE:** Examples of the database migrations can be found in the [`spec/support/schema.rb`](spec/support/schema.rb) file.

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

**NOTE:** Examples of the model configurations can be found in the [`spec/support/models.rb`](spec/support/models.rb) file.

## Usage

The CanBe gem will provide you a lot methods to handle your type processing in an easy and consistent manner.

### Instantiating New Models

You can continue to instantiate your CanBe models by using the `new` method.  When you do, CanBe will ensure that the type of the record is assigned the default CanBe type for your model.

There are also some helper methods put on your model to make it easier to instantiate the type of model that you want.  These methods will take the form of `new_<CanBe type>`.  For example, you can call `Address.new_home_address`.  These methods will take the same parameters as the base `new` method provided by ActiveRecord.

### Creating New Models

You can continue to create your CanBe models by using the `create` method.  When you do, CanBe will ensure that the type of the record is assigned the default CanBe type for your model.

There are also some helper methods put on your model to make it easier to create the type of model that you want.  These methods will take the form of `create_<CanBe type>`.  For example, you can call `Address.create_home_address`.  These methods will take the same parameters as the base `create` method provided by ActiveRecord.

### Changing CanBe Types (the "change_to" methods)

There are several ways to change the type of record that you are working with.  You can access the `can_be_type` attribute (or other attribute if you specified the field to be used) and change the value directly.

There are also instance methods provided on your model that allow for changing to a specific CanBe type.

You can change the type of record and not persist it immediately to the database by calling the appropriate `change_to_<CanBe type>` method.  For example, you can call `Address.new.change_to_work_address` method to change the record to be of CanBe type `:work_address`.

If you want to change the type of the record and persist it to the database immediately, you can call the appropriate `change_to_<CanBe type>!` method.  For example, this method call will change the type of record to `:work_address` and persist the change to the database: `Address.create.change_to_work_address!`

There is a validator for the CanBe field, that will ensure that the CanBe field is set to one of the CanBe types before persisting the record.

### Boolean Evaluation

With CanBe, it is easy to determine the type of record that you are working with.  This is accomplished by calling the `<CanBe type>?` on the instance of your model.  For example if you wanted to see if the `Address` instance you are working with, you would call `Address.first.home_address?` and it would return `true` or `false` depending on the CanBe type of the record.

### Finding Records

There are two ways to find specific types of records.  You can use the `find_by_can_be_types` method, which takes in a list of the CanBe types that you want to find.  For example, if you wanted to find all of the home and work addresses you would call `Address.find_by_can_be_types :home_address, :work_address`.

Methods are also defined on your CanBe model that will find all of the records for a specific CanBe type.  These methods take the form of `<pluralized CanBe type>`.  For example, `Address.home_addresses` would return all of the records with a type of `:home_address`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
    * Make sure to include the appropriate specs
    * Specs can be run by executing the `rake` command in the terminal
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

See [LICENSE.txt](LICENSE.txt).
