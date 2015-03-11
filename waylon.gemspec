$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)

require 'waylon/version'

Gem::Specification.new do |s|
  s.name          = 'waylon'
  s.version       = Waylon::VERSION
  s.date          = '2015-03-11'
  s.authors       = ['Roger Ignazio']
  s.email         = ['me@rogerignazio.com']
  s.homepage      = 'https://github.com/rji/waylon'
  s.summary       = 'Waylon is a dashboard to display the status of your Jenkins builds.'
  s.description   = s.summary
  s.license       = 'Apache License, Version 2.0'

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ['lib']

  s.required_ruby_version = '~> 2.1.0'

  s.add_runtime_dependency 'sinatra',            '~> 1.4'
  s.add_runtime_dependency 'jenkins_api_client', '~> 1.0'
  s.add_runtime_dependency 'deterministic',      '~> 0.6'
  s.add_runtime_dependency 'memcached',          '~> 1.8'
end
