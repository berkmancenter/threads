# frozen_string_literal: true
source 'https://rubygems.org'

ruby '2.3.3'

gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
gem 'pg',    '~> 0.18'
gem 'puma',  '~> 3.0'

gem 'bootstrap-sass', '3.3.6'
gem 'sass-rails',     '~> 5.0'
gem 'uglifier',       '>= 1.3.0'
gem 'coffee-rails',   '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'

gem 'devise'
gem 'redis', '~> 3.0'
gem 'bcrypt', '~> 3.1.7'
gem 'enumerize'
gem 'carrierwave'
gem 'active_model_serializers', '~> 0.10.0'

group :development, :test do
  gem 'bullet'

  gem 'pry-rails'
  gem 'pry-doc'
  gem 'pry-stack_explorer'
  gem 'pry-byebug'
  gem 'pry-coolline'

  gem 'awesome_print'

  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'faker'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'annotate'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'spring-commands-rspec'
  gem 'spring-commands-rubocop'

  gem 'rubocop', '~> 0.42.0', require: false
  gem 'rails_best_practices', require: false
  gem 'brakeman', require: false

  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test do
  gem 'simplecov', require: false
  gem 'shoulda-matchers'
  gem 'database_rewinder'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
