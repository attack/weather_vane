module WeatherVane
  class Wunderground < Service
    CURRENT_API_URL = 'http://api.wunderground.com/auto/wui/geo/WXCurrentObXML/index.xml'
    DEFAULT_PARAMS = {:query => 'KSFO'}
     
    class << self
      def validate_api!
        VCR.use_cassette(:wunderground, :record => :all) do
          connection = Faraday.new(:url => CURRENT_API_URL) do |faraday|
            faraday.headers['accept-encoding'] = 'none'
            faraday.adapter Faraday.default_adapter
          end
          connection.get(nil, DEFAULT_PARAMS)
        end        
      end
    
      def enable
        VCR.use_cassette(:wunderground, :record => :once) do
          config = ResponseConfiguration.new
          response = yield config
          
          injected_response(response, config)
        end
      end
      
      private
      
      def injected_response(response, config)
        parsed_response = WeatherVane::XmlReader.parse(response.body)
        merged_response = WeatherVane::HashMerger.deep_merge(parsed_response, config.response)
        response.env[:body] = WeatherVane::XmlWriter.xml(merged_response)
        
        response
      end
    end
    
  end
end