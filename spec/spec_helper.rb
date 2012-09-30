require 'rspec'

require 'webmock/rspec'
require 'gyoku'
Gyoku.convert_symbols_to :none

$:.unshift((File.join(File.dirname(__FILE__), '..', 'lib')))
require 'fake_weather'

RSpec.configure do |config|  
end