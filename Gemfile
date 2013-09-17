source 'https://rubygems.org'

ruby '2.0.0'


gem 'pg'
gem 'rails'
gem 'jquery-rails'
gem 'slim-rails'
gem 'resque'

gem 'devise'
gem 'cancan'

gem 'will_paginate'
gem 'will_paginate-bootstrap'

gem 'redcarpet'

gem 'paper_trail', git: 'git://github.com/airblade/paper_trail.git', branch: 'rails4'
gem 'differ'

gem 'draper'

gem 'tire'

gem 'activerecord-import'


group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'haml_coffee_assets'
  gem 'execjs'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'colorize'
  gem 'letter_opener'
end

gem 'pry',         group: [:development, :test]
gem 'rspec-rails', group: [:development, :test]
group :test do
  gem 'factory_girl_rails'
  gem 'simplecov'
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
end

group :production do
  gem 'unicorn'
  gem 'rails_12factor'
  gem 'newrelic_rpm'
end
