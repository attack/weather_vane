require 'rspec'
require 'pry'
require 'timecop'

require 'webmock/rspec'
require 'gyoku'
Gyoku.convert_symbols_to :none

$:.unshift((File.join(File.dirname(__FILE__), '..', 'lib')))
require 'weather_vane'

RSpec.configure do |config|  
end