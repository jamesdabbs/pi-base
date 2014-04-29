source 'https://rubygems.org'

ruby "2.1.1"

# Data
gem 'pg'
gem 'kaminari'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

# Infrastructure
gem 'rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'thin'
gem 'slim-rails'
gem 'sucker_punch'

# Auth
gem 'devise'
gem 'cancan'

# Presentation
gem 'will_paginate'
gem 'will_paginate-bootstrap'
gem 'redcarpet'
gem 'paper_trail'
gem 'differ'
gem 'draper'

# Monitoring
gem 'exceptiontrap'

group :assets do
  gem 'sprockets', '2.11.0'
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'haml_coffee_assets'
  gem 'execjs'
end

group :development do
  gem 'letter_opener'
  gem 'pry-rails'
  gem 'quiet_assets'

  # Legacy importer
  gem 'activerecord-import'
  gem 'mysql2'
  gem 'sequel'
end

group :development, :test do
  gem 'bullet'

  gem 'spring'
  gem 'spring-commands-rspec'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'rspec-rails', '~> 3.0.0.beta1'
  gem 'simplecov'
end

group :production do
  gem 'passenger'
  gem 'rails_12factor'
end
