# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'can_be/version'

Gem::Specification.new do |gem|
  gem.name          = "can_be"
  gem.version       = CanBe::VERSION
  gem.authors       = ["Mark Starkman"]
  gem.email         = ["mrstarkman@gmail.com"]
  gem.description   = %q{CanBe allows you to track the type of your ActiveRecord model in a consistent simple manner.  With just a little configuration on your part, each type of record can contain different attributes that are specifc to that type of record.}
  gem.summary       = %q{CanBe allows you to track the type of your ActiveRecord model in a consistent simple manner.  With just a little configuration on your part, each type of record can contain different attributes that are specifc to that type of record.  From a data modelling perspective this is preferred over ActiveRecord STI since you will not have many columns in your database that have null values.  Under the hood, CanBe uses one-to-one Polymorphic Associations to accomplish the different attributes per type.}
  gem.homepage      = ""

  gem.required_ruby_version = '>= 1.9.2'
  gem.files                 = `git ls-files`.split($/)
  gem.executables           = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files            = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths         = ["lib"]

  gem.add_development_dependency('rspec', '~> 2.0')
  gem.add_development_dependency('sqlite3')
  gem.add_development_dependency('database_cleaner')
  gem.add_development_dependency('rake')
  gem.add_development_dependency('pry')

  gem.add_dependency("activerecord", "~> 3.1")
  gem.add_dependency("activesupport", "~> 3.1")
end
