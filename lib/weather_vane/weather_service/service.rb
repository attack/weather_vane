$:.unshift(File.dirname(__FILE__))
require 'faraday'
require 'vcr'

require "weather_vane/weather_service/response_configuration"

VCR.configure do |c|
  c.cassette_library_dir = 'cassettes'
  c.allow_http_connections_when_no_cassette = true
  c.hook_into :faraday
end

module WeatherVane
  class Service
  end
end

require "weather_vane/weather_service/wunderground"