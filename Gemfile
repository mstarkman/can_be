source 'https://rubygems.org'

can_be_env = ENV['CAN_BE_ENV'] || '3.2'

unless ENV['CAN_BE_ENV'].nil?
  eval(File.read(File.join(File.dirname(__FILE__), 'gemfiles', "#{can_be_env}.gemfile")), binding)
end

# Specify your gem's dependencies in can_be.gemspec
gemspec

