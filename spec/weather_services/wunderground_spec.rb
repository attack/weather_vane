require 'spec_helper'

describe "FakeWeather::Wunderground" do
  WUNDEGROUND_REGEX = /.*api.wunderground.com.*WXCurrentObXML.*/
  
  describe "#api_valid?" do
    it "gets data from Wunderground with default query" do
      stub = stub_request(:get, WUNDEGROUND_REGEX).with(:query => {"query" => "KSFO"})
      
      FakeWeather::Wunderground.api_valid?
      
      stub.should have_been_requested
    end
    
    context "when all required fields are found" do
      it "returns true" do
        WebMock.disable!
        FakeWeather::Wunderground.api_valid?.should be_true
        WebMock.enable!
      end
    end
    
    context "when one or many fields are not found" do
      it "throws an error if expected field not found" do
        response = Gyoku.xml( :current_observation => {} )
        stub_request(:get, WUNDEGROUND_REGEX).
          to_return(:body => response, :status => 200)

        FakeWeather::Wunderground.api_valid?.should be_false
      end
    end
  end
end