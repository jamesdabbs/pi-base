RSpec.configure do |config|
  config.before :all, :job do
    [Space, Property, Trait, Theorem].each &:delete_all
  end
  config.around :each, job: false do |ex|
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.cleaning { ex.run }
  end
end
