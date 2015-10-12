source 'https://rubygems.org'

ruby '1.9.3'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'
# Use sqlite3 as the database for Active Record
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'honeybadger', '~> 2.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development


group :production do
  gem 'pg'

  gem "wkhtmltopdf-heroku"
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails', '~> 3.0'

  gem "wkhtmltopdf-binary", "= 0.1.2"

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  #gem 'byebug'
  gem 'pry-byebug', platform: [:ruby_20]

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'capybara', :git => 'git://github.com/jnicklas/capybara.git'

  gem 'launchy'

  gem 'database_cleaner'

  gem 'selenium-webdriver'

end

group :test do
  gem 'factory_girl_rails'
end

gem "slim-rails"

gem "jquery-ui-rails"

gem "summernote-rails"

gem "font-awesome-rails"

gem "bootstrap-sass"

gem "rails_12factor"

gem "mandrill-api"

gem "pdfkit", "= 0.6.2"

gem 'font-awesome-sass'

gem 'kaminari'
