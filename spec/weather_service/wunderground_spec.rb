require 'spec_helper'

def get_default_xml_response
  url = WeatherVane::Wunderground::CURRENT_API_URL
  params = WeatherVane::Wunderground::DEFAULT_PARAMS
  
  connection = Faraday.new(:url => url) do |faraday|
    faraday.headers['accept-encoding'] = 'none'
    faraday.adapter Faraday.default_adapter
  end
  connection.get(nil, params)
end

describe "WeatherVane::Wunderground" do
  before(:all) do
    WebMock.disable!
    WeatherVane::Wunderground.validate_api!
    WebMock.enable!
  end
  
  describe ".enable" do
    context "when enabled" do
      it "does not allow request through" do
        stub = stub_request(:get, WeatherVane::Wunderground::CURRENT_API_URL).
          with(:query => WeatherVane::Wunderground::DEFAULT_PARAMS)
      
        WeatherVane::Wunderground.enable do
          get_default_xml_response
        end
      
        stub.should_not have_been_requested
      end
    end
  
    context "when not enabled" do
      it "allows the request through" do
        stub = stub_request(:get, WeatherVane::Wunderground::CURRENT_API_URL).
          with(:query => WeatherVane::Wunderground::DEFAULT_PARAMS)
    
        get_default_xml_response
    
        stub.should have_been_requested
      end
    end
  end
  
  describe "injecting values" do
    context "when no values are injected" do
      it "returns the default response" do
        response = WeatherVane::Wunderground.enable do
          get_default_xml_response
        end
        
        parsed_response = WeatherVane::XmlReader.parse(response.body)
        parsed_response["current_observation"]["station_id"].should == "KSFO"
      end
    end
  
    context "when values are injected" do
      it "includes the values in the response" do
        response = WeatherVane::Wunderground.enable do |wunderground|
          wunderground.response = {
            'current_observation' => {
              'station_id' => 'KJFK'
            }
          }
          
          get_default_xml_response
        end
        
        parsed_response = WeatherVane::XmlReader.parse(response.body)
        parsed_response["current_observation"]["station_id"].should == "KJFK"
      end
    end
  end
end