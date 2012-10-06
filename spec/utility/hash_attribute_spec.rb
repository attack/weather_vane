require 'spec_helper'

describe WeatherVane::HashAttribute do
  describe ".convert" do
    it "converts a normal hash without @ keys" do
      hash_without_ampersands = {
        "person" => { "name" => "John Smith" }
      }
    
      hash_without_attributes = WeatherVane::HashAttribute.convert(hash_without_ampersands)
    
      hash_without_attributes.should == {
        "person" => { "name" => "John Smith" }
      }
    end
  
    it "converts @ keys to !attribute keys" do
      hash_with_ampersands = {
        "person" => {
          "name" => "John Smith",
          "@gender" => "Male"
        }
      }
    
      hash_with_attributes = WeatherVane::HashAttribute.convert(hash_with_ampersands)
    
      hash_with_attributes.should == {
        "person" => { "name" => "John Smith" },
        :attributes! => {
          "person" => { "gender" => "Male" }
        }
      }
    end
  
    it "converts @ keys at multiple levels" do
      hash_with_ampersands = {
        "outer" => {
          "person" => {
            "name" => "John Smith",
            "@gender" => "Male"
          }
        }
      }
    
      hash_with_attributes = WeatherVane::HashAttribute.convert(hash_with_ampersands)
    
      hash_with_attributes.should == {
        "outer" => {
          "person" => { "name" => "John Smith" },
          :attributes! => {
            "person" => { "gender" => "Male" }
          }
        }
      }
    end
  
    it "converts array elements" do
      hash_with_ampersands = {
        "icon_set" => [
          {
            "icon_url"=>"http://icons-ak.wxug.com/i/c/a/partlycloudy.gif",
            "@name"=>"Default"
          },
          {
            "icon_url"=>"http://icons-ak.wxug.com/i/c/b/partlycloudy.gif",
            "@name"=>"Smiley"
          }
        ]
      }
          
      hash_with_attributes = WeatherVane::HashAttribute.convert(hash_with_ampersands)   
    
      hash_with_attributes.should == {
        "icon_set" => [
          { "icon_url" =>"http://icons-ak.wxug.com/i/c/a/partlycloudy.gif" },
          { "icon_url" => "http://icons-ak.wxug.com/i/c/b/partlycloudy.gif" }
        ],
        :attributes! => {"icon_set"=>{"name"=>["Default","Smiley"]}}
      }
    end
  
    it "converts array elements without attrs" do
      hash_without_ampersands = {
        "icons" => {
          "icon_set" => [
            { "icon_url"=>"http://icons-ak.wxug.com/i/c/a/partlycloudy.gif" },
            { "icon_url"=>"http://icons-ak.wxug.com/i/c/b/partlycloudy.gif" }
          ]
        }
      }
          
      hash_without_attributes = WeatherVane::HashAttribute.convert(hash_without_ampersands)   
    
      hash_without_attributes.should == {
        "icons" => {
          "icon_set" => [
            { "icon_url" =>"http://icons-ak.wxug.com/i/c/a/partlycloudy.gif" },
            { "icon_url" => "http://icons-ak.wxug.com/i/c/b/partlycloudy.gif" }
          ]
        }
      }
    end
    
    it "compounds attrs on the same level" do
      multiple_attrs_hash = {
        "person" => {
          "name" => "Foo Bar",
          "@id" => 1
        },
        "dog" => {
          "name" => "Bar Foo",
          "@id" => 2
        }
      }
      
      multiple_attrs_result = WeatherVane::HashAttribute.convert(multiple_attrs_hash)   
  
      multiple_attrs_result.should == {
        "person" => { "name" => "Foo Bar"},
        "dog" => { "name" => "Bar Foo"},
        :attributes! => {
          "person" => { "id" => 1 },
          "dog" => { "id" => 2 }
        }
      }
    end
    
    it "converts a complex hash, multiple levels, multiple syles" do
      complex_hash = {
        "first" => "first value",
        "container" => {
          "set1" => [
            {
              "item" => { "name" => "Foo", "@class" => "Oof" },
              "@style" => "Bar"
            },
            {
              "item" => { "name" => "Baz", "@class" => "Zab" },
              "@style" => "Foz"
            }
          ],
          "@id" => 33,
          "second" => "second value"
        },
        "set2" => [
          {
            "url" => "http://example.com/foo_bar",
            "@name" => "FooBar",
            "params" => { "type" => "Foo", "name" => "Bar" }
          },
          {
            "url" => "http://example.com/bar_foo",
            "@name" => "BarFoo"
          }
        ]
      }
      
      complex_result = WeatherVane::HashAttribute.convert(complex_hash)   
  
      complex_result.should == {
        "first" => "first value",
        "container" => {
          "set1" => [
            {
              "item" => { "name" => "Foo" },
              :attributes! => {"item" => {"class" => "Oof"}}
            },
            {
              "item" => { "name" => "Baz" },
              :attributes! => {"item" => {"class" => "Zab"}}
            }
          ],
          :attributes! => {"set1" => {"style" => ["Bar", "Foz"]}},
          "second" => "second value"
        },
        "set2" => [
          {
            "url" => "http://example.com/foo_bar",
            "params" => { "type" => "Foo", "name" => "Bar" }
          },
          { "url" => "http://example.com/bar_foo" }
        ],
        :attributes! => {"container" => {"id" => 33}, "set2" => {"name" => ["FooBar", "BarFoo"]}}
      }
    end
  end

  describe ".partition_array" do
    it "removes @ keys from array" do
      array_with_attrs = [
        {"person" => "John Smith", "@gender" => "Male"},
        {"person" => "Jane Smith", "@gender" => "Female"}
      ]
      
      array_without_attrs, x = WeatherVane::HashAttribute._partition_array(array_with_attrs)
      
      array_without_attrs.should == [
        {"person" => "John Smith"},
        {"person" => "Jane Smith"}
      ]
    end
    
    it "collects @ values" do
      array_with_attrs = [
        {"person" => "John Smith", "@gender" => "Male"},
        {"person" => "Jane Smith", "@gender" => "Female"}
      ]

      x, collected_attrs = WeatherVane::HashAttribute._partition_array(array_with_attrs)

      collected_attrs.should == {
        "@gender" => ["Male", "Female"]
      }
    end
    
    it "removes multiple @ keys from array" do
      array_with_attrs = [
        {"person" => "John Smith", "@gender" => "Male", "@age" => 34},
        {"person" => "Jane Smith", "@gender" => "Female", "@age" => 18}
      ]

      array_without_attrs, x = WeatherVane::HashAttribute._partition_array(array_with_attrs)

      array_without_attrs.should == [
        {"person" => "John Smith"},
        {"person" => "Jane Smith"}
      ]
    end

    it "collects multiple @ values" do
      array_with_attrs = [
        {"person" => "John Smith", "@gender" => "Male", "@age" => 34},
        {"person" => "Jane Smith", "@gender" => "Female", "@age" => 18}
      ]

      x, collected_attrs = WeatherVane::HashAttribute._partition_array(array_with_attrs)

      collected_attrs.should == {
        "@gender" => ["Male", "Female"],
        "@age" => [34, 18]
      }
    end
  end
end