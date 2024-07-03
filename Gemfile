source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: '.ruby-version'

gem 'aws-sdk-s3'
gem 'bootsnap', '>= 1.1.0', require: false
gem 'jbuilder'
gem 'mission_control-jobs'
gem 'mysql2', '~> 0.5'
gem 'puma', '>= 5.0'
gem 'rails'
gem 'rmagick'
gem 'sass-rails'
gem 'solid_queue'
gem 'turbolinks'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'vite_rails'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'fuubar'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'spring-commands-rspec'
end

group :development do
  gem 'annotate'
  gem 'brakeman', require: false
  gem 'listen'
  gem 'rbs-inline', require: false
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec'
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'steep', require: false
  gem 'web-console'
end
