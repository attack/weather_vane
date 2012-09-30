# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'weather_vane/version'

Gem::Specification.new do |gem|
  gem.name          = "weather_vane"
  gem.version       = WeatherVane::VERSION
  gem.authors       = ["Mark G"]
  gem.email         = ["rtec88@gmail.com"]
  gem.description   = %q{Multiple weather service fakes, to avoid http requests}
  gem.summary       = %q{Multiple weather service fakes, to avoid http requests}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.require_paths = ["lib"]
  
  gem.add_dependency 'webmock'
  gem.add_dependency 'gyoku'
  gem.add_dependency 'nori'
  
  gem.add_development_dependency 'rspec', '~> 2.6.0'
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'pry'
end
