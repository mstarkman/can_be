require 'active_record'
require 'database_cleaner'
require 'logger'
require 'support/model_macros'

require 'can_be'

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
ActiveRecord::Base.logger = Logger.new(File.join(File.dirname(__FILE__), "../log/debug.log"))
ActiveRecord::Base.send(:include, CanBe::ModelExtensions)

# now that we have the database configured, we can create the models and
# migrate the database
require 'support/models'

RSpec.configure do |config|
  config.include ModelMacros

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
