require 'spec_helper'

describe WeatherVane::XmlReader do
  let(:xml) { "<item>Foo</item>" }
  
  it "converts XML to a Hash" do
    WeatherVane::XmlReader.parse(xml).should == {"item" => "Foo"}
  end
  
  it "wraps Nori" do
    Nori.should_receive('parse').with(xml)
    
    WeatherVane::XmlReader.parse(xml)
  end
  
  it "uses Nokogiri" do
    parser = stub('parser').as_null_object
    Nokogiri::XML::SAX::Parser.should_receive('new').and_return(parser)
    
    WeatherVane::XmlReader.parse(xml)
  end
end