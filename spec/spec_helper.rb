$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'active_record'
require 'hstore-document'
require 'pry'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

I18n.enforce_available_locales = true

RSpec.configure do |config|
  config.before(:suite) do
    ActiveRecord::Base.establish_connection({
      adapter: 'postgresql',
      encoding: 'unicode',
      database: 'hstore_document',
      username: 'postgres',
      password: 'postgres',
      host: 'localhost'
    })
    # ActiveRecord::Base.logger = Logger.new(STDERR)
  end

  config.after(:suite) do
  end
end
