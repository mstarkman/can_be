# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'can_be/version'

Gem::Specification.new do |gem|
  gem.name          = "can_be"
  gem.version       = CanBe::VERSION
  gem.authors       = ["Mark Starkman"]
  gem.email         = ["mrstarkman@gmail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency('rspec', '~> 2.0')
  gem.add_development_dependency('sqlite3')
  gem.add_development_dependency('database_cleaner')

  gem.add_dependency("activerecord", "~> 3.1")
  gem.add_dependency("activesupport", "~> 3.1")
end
