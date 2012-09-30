# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fake_weather/version'

Gem::Specification.new do |gem|
  gem.name          = "fake_weather"
  gem.version       = FakeWeather::VERSION
  gem.authors       = ["Mark G"]
  gem.email         = ["rtec88@gmail.com"]
  gem.description   = %q{Multiple weather service fakes, to avoid http requests}
  gem.summary       = %q{Multiple weather service fakes, to avoid http requests}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = ["lib"]
  
  gem.add_development_dependency 'rspec', '~> 2.6.0'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'pry'
end
