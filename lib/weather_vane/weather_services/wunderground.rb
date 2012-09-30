module WeatherVane
  class Wunderground < Service
    API_URL = "http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml"
    
    EXPECTED_DATA_FORMAT = {
      :current_observation => {
        :station_id => 'STATION_ID'
      }
    }
    
    def self.api_valid?
      response = http_get(API_URL, {:query => 'KSFO'})
      WeatherVane::HashComparer.valid?(response, EXPECTED_DATA_FORMAT)
    end
  end
end