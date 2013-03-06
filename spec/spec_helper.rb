$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))

MODELS = File.join(File.dirname(__FILE__), "app/models")
$LOAD_PATH.unshift(MODELS)

require "mongoid"
require "i18n"
require "mongoid/localizer"
require "rspec"

def database_id
  "mongoid_localizer_test"
end

Mongoid.configure do |config|
  config.connect_to(database_id, consistency: :strong)
end

# Autoload every model for the test suite that sits in spec/app/models.
Dir[ File.join(MODELS, "*.rb") ].sort.each do |file|
  name = File.basename(file, ".rb")
  autoload name.camelize.to_sym, name
end

RSpec.configure do |config|

  # Drop all collections and clear the identity map before each spec.
  config.before(:each) do
    Mongoid.purge!
    Mongoid::IdentityMap.clear
  end
end
