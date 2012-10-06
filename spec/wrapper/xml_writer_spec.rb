require 'spec_helper'

describe WeatherVane::XmlWriter do
  let(:hash) { {:item => "Foo"} }
  
  it "converts a Hash into XML" do
    WeatherVane::XmlWriter.xml(hash).should == "<item>Foo</item>"
  end
  
  it "wraps Gyoku" do
    Gyoku.should_receive('xml').with(hash)
    WeatherVane::XmlWriter.xml(hash)
  end
  
  it "does not convert symbols to CamelCase" do
    hash = { :special_item => "FooBar" }
    
    WeatherVane::XmlWriter.xml(hash).should_not == "<specialItem>FooBar</specialItem>"
    WeatherVane::XmlWriter.xml(hash).should == "<special_item>FooBar</special_item>"
  end
  
  it "accepts Nori style '@' attributes" do
    hash = {
      :item => {
        :name => "Foo",
        '@type' => "Bar"
      }
    }
    
    xml = "<item type=\"Bar\"><name>Foo</name></item>"
    
    WeatherVane::XmlWriter.xml(hash).should == xml
  end
end