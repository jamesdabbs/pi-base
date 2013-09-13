ENV["RAILS_ENV"] ||= 'test'

if ENV['COVERAGE']
  require 'simplecov'

  SimpleCov.start
end

require 'pry'

RSpec.configure do |config|
  config.order = "random"
end

RAILS_ROOT = Pathname.new File.expand_path('../..', __FILE__)

def require_local path
  require RAILS_ROOT.join path
end

def data path
  RAILS_ROOT.join 'spec', 'data', path
end
