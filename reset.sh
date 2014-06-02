#!/bin/bash
psql -c 'DROP DATABASE brubeck_dev'
heroku pg:pull DATABASE_URL brubeck_dev
bundle exec rake db:migrate
bundle exec rails runner reset.rb
bundle exec rails console
