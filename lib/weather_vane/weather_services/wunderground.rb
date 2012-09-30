module WeatherVane
  class Wunderground < Service
    CURRENT_API_URL = 'http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml'
    
    EXPECTED_DATA_FORMAT = {
      :current_observation => {
        :station_id => 'TEXT',
        :observation_time => 'DATETIME',
        :credit => 'TEXT',
        :credit_URL => 'TEXT',
        
        :relative_humidity => 'TEXT',
        :icon => 'TEXT',
        :temp_c => 'TEXT',
        :temp_f => 'TEXT',
        :wind_mph => 'TEXT',
        :wind_degrees => 'TEXT',
        :wind_dir => 'TEXT',
        :pressure_mb => 'TEXT',
        :pressure_in => 'TEXT',
        :dewpoint_c => 'TEXT',
        :dewpoint_f => 'TEXT',
        :heat_index_c => 'TEXT',
        :heat_index_f => 'TEXT',
        :windchill_c => 'TEXT',
        :windchill_f => 'TEXT',
        :visibility_km => 'TEXT',
        :visibility_mi => 'TEXT',
        
        :display_location => {
          :full => 'TEXT',
          :city => 'TEXT',
          :state_name => 'TEXT',
          :state => 'TEXT',
          :country => 'TEXT',
          :zip => 'TEXT',
          :latitude => 'TEXT',
          :longitude => 'TEXT'
        },
        
        :observation_location => {
          :full => 'TEXT',
          :city => 'TEXT',
          :state => 'TEXT',
          :country => 'TEXT',
          :latitude => 'TEXT',
          :longitude => 'TEXT'
        }
      }
    }
    
    def self.api_missing
      response = http_get(:wunderground_api_check, CURRENT_API_URL, {:query => 'KSFO'})
      WeatherVane::HashComparer.missing(response, EXPECTED_DATA_FORMAT)
    end
  end
end