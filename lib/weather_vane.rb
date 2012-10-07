$:.unshift(File.dirname(__FILE__))

require "weather_vane/version"
require "weather_vane/utility/utility"
require "weather_vane/wrapper/wrapper"
require "weather_vane/weather_service/service"

module WeatherVane
  def self.ruby_19?
    RUBY_VERSION >= "1.9"
  end
end