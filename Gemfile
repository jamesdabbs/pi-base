source 'https://rubygems.org'

ruby "2.1.1"

gem 'rails', '~> 4.1.0.beta1'
gem 'jquery-rails'
gem 'thin'
gem 'slim-rails'
gem 'resque'
gem 'exceptiontrap'

gem 'pg'

gem 'devise'
gem 'cancan'

gem 'will_paginate'
gem 'will_paginate-bootstrap'

gem 'redcarpet'

gem 'paper_trail'
gem 'differ'

gem 'draper'

gem 'kaminari'
gem 'elasticsearch-model'
gem 'elasticsearch-rails'

group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'haml_coffee_assets'
  gem 'execjs'
end

group :development do
  gem 'colorize'
  gem 'letter_opener'
  gem 'pry-rails'
  gem 'quiet_assets'

  # Legacy importer
  gem 'activerecord-import', require: false
  gem 'mysql2'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0.0.beta1'
end

group :test do
  gem 'factory_girl_rails'
  gem 'simplecov'
end

group :production do
  gem 'passenger'
  gem 'rails_12factor'
end
