source 'https://rubygems.org'

gem 'sinatra',            '~> 1.4'
gem 'unicorn',            '~> 4.8'
gem 'jenkins_api_client', '~> 1.0'
gem 'deterministic',      '~> 0.6'
gem 'memcached',          '~> 1.8'

group :development do
  gem 'foreman'
end

if File.exists? "#{__FILE__}.local"
  eval(File.read("#{__FILE__}.local"), binding)
end
