require 'spec_helper'
require 'nori'

describe Nori do
  it "uses '@' for attributes" do
    xml = <<-XML
      <item type="Bar">
        <name>Foo</name>
      </item>
    XML
  
    generated_hash = Nori.parse(xml)

    hash = {
      "item" => {
        "name" => "Foo",
        "@type" => "Bar"
      }
    }
  
    generated_hash.should == hash
  end

  it "converts complex XML into a Hash" do
    xml = <<-XML
      <outer>
        <gem>Gyoku</gem>
        <inner>
          <title count="2">List</title>
          <items>
            <item type="Baz"><name>Foo</name></item>
            <item type="Foz"><name>Bar</name></item>
          </items>
        </inner>
      </outer>
    XML
    
    generated_hash = Nori.parse(xml)
  
    hash = {
      "outer" => {
        "gem" => "Gyoku",
        "inner" => {
          "title" => "List",
          "items" => {
            "item" => [
              {
                "name" => "Foo",
                "@type" => "Baz"
              },
              {
                "name" => "Bar",
                "@type" => "Foz"
              }
            ]
          }
        }
      }
    }
    
    generated_hash.should == hash
  end
  
  it "does not support attributes on nodes" do
    xml = <<-XML
      <title count="2">List</title>
    XML
    
    generated_hash = Nori.parse(xml)
    
    desired_hash = {
      "title" => {
        "something_to_represent_value" => "List",
        "@count" => "2"
      }
    }
    
    actual_hash = {
      "title" => "List"
    }
    
    generated_hash.should_not == desired_hash
    generated_hash.should == actual_hash
  end
end