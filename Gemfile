# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

gem 'i18n'
gem 'rspec_junit_formatter', '~> 0.4.1'

group :development do
  gem 'fasterer'
  gem 'overcommit', '~> 0.53.0', require: false
  gem 'pry'
  gem 'rubocop'
  gem 'rubocop-rspec'
  gem 'solargraph'
end

group :test do
  gem 'rspec', '~> 3.8'
  gem 'simplecov'
  gem 'simplecov-lcov'
  gem 'undercover'
end
