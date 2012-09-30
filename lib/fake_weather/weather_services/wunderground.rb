module FakeWeather
  class Wunderground < Service
    
    EXPECTED_DATA_FORMAT = {
      :current_observation => {
        :station_id => 'STATION_ID'
      }
    }
    
    def self.api_valid?
      uri = URI("http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml")
      uri.query = URI.encode_www_form({:query => 'KSFO'})

      response = Net::HTTP.get_response(uri)
      hash_response = Nori.parse(response.body)
      
      HashComparer.valid?(hash_response, EXPECTED_DATA_FORMAT)
    end
    
  end
end