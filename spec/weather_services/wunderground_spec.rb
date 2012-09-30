require 'spec_helper'

describe "WeatherVane::Wunderground" do  
  describe "#api_valid?" do
    it "gets data from Wunderground with default query" do
      stub = stub_request(:get, WeatherVane::Wunderground::API_URL).with(:query => {"query" => "KSFO"})
      
      WeatherVane::Wunderground.api_valid?
      
      stub.should have_been_requested
    end
    
    context "when all required fields are found" do
      it "returns true" do
        WebMock.disable!
        WeatherVane::Wunderground.api_valid?.should be_true
        WebMock.enable!
      end
    end
    
    context "when one or many fields are not found" do
      it "throws an error if expected field not found" do
        response = Gyoku.xml( :current_observation => {} )
        stub_request(:get, WeatherVane::Wunderground::API_URL).
          with(:query => {"query" => "KSFO"}).
          to_return(:body => response, :status => 200)

        WeatherVane::Wunderground.api_valid?.should be_false
      end
    end
  end
end