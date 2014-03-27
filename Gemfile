source 'https://rubygems.org'

ruby '1.9.3'

gem 'rails', '3.2.14'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

group :development, :test do
   gem 'sqlite3'
   gem 'rspec-rails'
   gem 'capybara'
   gem 'selenium-webdriver'
   gem 'database_cleaner'
end

group :production do
  gem 'pg'
  gem 'rails_12factor'
end

gem 'faker'
gem "will_paginate", "~> 3.0.4"
gem 'bootstrap-will_paginate'
gem "therubyracer"
gem "less-rails"
gem "twitter-bootstrap-rails"
gem 'letsrate'
gem "rufus-scheduler", "~> 3.0.2"
gem 'delorean'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  gem 'twitter-bootstrap-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

#suggested gems by Todd
gem 'factory_girl_rails'
gem 'rspec-rails'
gem 'devise'

# gems added for Test driven development (either helpers or others)
gem 'database_cleaner'
#gem 'cucumber-rails', :group => :test, :require => false
gem 'capybara'
gem 'selenium-webdriver'
gem 'email_spec'
gem 'rails_best_practices'
gem 'debugger', group: [:development, :test]

group :development do
#  gem 'ruby-debug-base19x'
#  gem 'ruby-debug-ide'
end
