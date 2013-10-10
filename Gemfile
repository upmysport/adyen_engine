source 'https://rubygems.org'

# Declare your gem's dependencies in adyen.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

gem 'adyen', git: 'git://github.com/upmysport/adyen.git', branch: 'just_core'

group :development, :test do
  # jquery-rails is used by the dummy application
  gem 'jquery-rails'
  gem 'sqlite3'
  gem 'rspec-rails', '~> 2.14'
  gem 'factory_girl_rails'
end
