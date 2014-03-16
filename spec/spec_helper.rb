ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'pry'
require 'sucker_punch/testing/inline'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

# -- Custom helpers and matchers -----

RSpec::Matchers.define :satisfy do |formula|
  match do |space|
    !!formula.verify(space)
  end

  failure_message do |space|
    "#{space.name} should satisfy #{formula}"
  end

  failure_message_when_negated do |space|
    "#{space.name} should not satisfy #{formula}"
  end
end

# -- RSpec configuration -----

RSpec.configure do |config|
  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  # Allow focusing on specs
  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  # Typing `FactoryGirl` is just too arduous
  config.include FactoryGirl::Syntax::Methods

  # Need to make sure these exist to that e.g. formulae can deserialize them
  config.before :all do
    Value.true.save!
    Value.false.save!
  end

  # Make sure we're cleaning compatibly with sucker_punch
  config.before :all, :job do
    [Space, Property, Trait, Theorem].each &:delete_all
  end
  config.around :each, job: false do |ex|
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.cleaning { ex.run }
  end
end

# -- Coverage -----

require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
  add_filter '/config/'
  add_filter '/lib/'
  add_filter '/vendor/'

  add_group 'Controllers', 'app/controllers'
  add_group 'Models',      'app/models'
  add_group 'Helpers',     'app/helpers'
  add_group 'Mailers',     'app/mailers'
  add_group 'Views',       'app/views'
end if ENV['COVERAGE']

