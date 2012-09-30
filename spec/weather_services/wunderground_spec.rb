require 'spec_helper'

def ensure_fresh_and_valid_casette!
  WebMock.disable!
  WeatherVane::Wunderground.allow_next_connection!
  WeatherVane::Wunderground.api_valid?
  WebMock.enable!
end

def guarantee_api_request
  # not necc. unstopped by webmock
  WeatherVane::Wunderground.allow_next_connection!
end

def clear_all_stubs
  WebMock.reset!
end

describe "WeatherVane::Wunderground" do  
  describe "#api_missing" do
    it "warns when api has changed" do
      ensure_fresh_and_valid_casette!
      WeatherVane::Wunderground.api_missing.should == []
    end
  end
  
  describe "#api_valid?" do
    before do
      clear_all_stubs
    end
    
    it "gets data from Wunderground with default query" do
      guarantee_api_request
      
      stub = stub_request(:get, WeatherVane::Wunderground::CURRENT_API_URL).with(:query => {"query" => "KSFO"})
      
      WeatherVane::Wunderground.api_valid?
      
      stub.should have_been_requested
    end
    
    it "only gets actual data once every 24 hours" do
      ensure_fresh_and_valid_casette!
      
      under_24_hours = 23 * 60 * 60
      Timecop.freeze(Time.now + under_24_hours) do
        stub = stub_request(:get, WeatherVane::Wunderground::CURRENT_API_URL).with(:query => {"query" => "KSFO"})
        WeatherVane::Wunderground.api_valid?
        stub.should_not have_been_requested
      end
      Timecop.return
      clear_all_stubs
      
      over_24_hours = 25 * 60 * 60
      Timecop.freeze(Time.now + over_24_hours) do
        stub = stub_request(:get, WeatherVane::Wunderground::CURRENT_API_URL).with(:query => {"query" => "KSFO"})
        WeatherVane::Wunderground.api_valid?
        stub.should have_been_requested
      end
      
      Timecop.return
    end
    
    context "when all required fields are found" do
      it "returns true" do
        ensure_fresh_and_valid_casette!
        WeatherVane::Wunderground.api_valid?.should be_true
      end
    end
    
    context "when one or many fields are not found" do
      it "throws an error if expected field not found" do
        guarantee_api_request
        
        response = Gyoku.xml( :current_observation => {} )
        stub_request(:get, WeatherVane::Wunderground::CURRENT_API_URL).
          with(:query => {"query" => "KSFO"}).
          to_return(:body => response, :status => 200)
    
        WeatherVane::Wunderground.api_valid?.should be_false
      end
    end
  end
  
  describe "#allow_next_connection!" do
    it "allows the next request to go through" do
      WeatherVane::Wunderground.api_valid?
      
      stub = stub_request(:get, WeatherVane::Wunderground::CURRENT_API_URL).with(:query => {"query" => "KSFO"})
      WeatherVane::Wunderground.api_valid?
      stub.should_not have_been_requested
      WebMock.reset!
      
      WeatherVane::Wunderground.allow_next_connection!
      stub = stub_request(:get, WeatherVane::Wunderground::CURRENT_API_URL).with(:query => {"query" => "KSFO"})
      WeatherVane::Wunderground.api_valid?
      stub.should have_been_requested
    end
  end
end