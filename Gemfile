source 'https://rubygems.org'

gem 'sinatra',            '~> 1.4.5'
gem 'jenkins_api_client', '~> 1.0.1'
gem 'deterministic',      '~> 0.6.0'
# These gems will not bundle on Windows platforms
gem 'unicorn',            '~> 4.8.3', :platform => :ruby
gem 'memcached',          '~> 1.8.0', :platform => :ruby

group :development do
  gem 'foreman'
  gem 'shotgun'
end

if File.exists? "#{__FILE__}.local"
  eval(File.read("#{__FILE__}.local"), binding)
end
