source 'https://rubygems.org'
ruby "1.9.3"

gem 'rails', '3.2.11'
gem 'haml-rails'
gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'bcrypt-ruby'
gem 'jquery-rails'
gem 'sidekiq'

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

group :development do
  gem 'sqlite3'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
end

group :production do
  gem 'pg'
end

group :test, :development do
  gem 'fabrication'
  gem 'faker'
	gem 'rspec-rails'
  gem 'pry'
  gem 'pry-nav'
  gem 'foreman'
end

group :test do
	gem "shoulda-matchers"
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'capybara-email'
end