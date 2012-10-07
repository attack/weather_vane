# WeatherVane

Multiple weather service fakes, to avoid http request

* NOTE - This gem is in the early stages of development and the API is still
being designed.  Use cautiously, feedback welcomed.

## Installation

Add this line to your application's Gemfile:

    gem 'weather_vane'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install weather_vane

## Usage

This is gem is used for two things:
- determine when a weather service API has changed and is different then what it is expected to be
- act as a fake weather service for :wunderground, to test your code against

Example
# response is intercepted
#
WeatherVane::Wunderground.enable do |wunderground|
  
  wunderground.response = {
    'station_id' => 'ID'
  }
  
  result = Barometer.measure
end

result.station_id == 'ID'


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request