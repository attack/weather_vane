require 'rspec'
require 'pry'
require 'webmock/rspec'

$:.unshift((File.join(File.dirname(__FILE__), '..', 'lib')))
require 'weather_vane'

RSpec.configure do |config|  
end

def ruby_19?
  RUBY_VERSION >= "1.9"
end