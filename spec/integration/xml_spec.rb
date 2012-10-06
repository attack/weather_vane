require 'spec_helper'

describe "XML reading + writing" do
  it "using XmlReader + XmlWriter can be used full circle" do
    abridged_wunderground_xml = <<-XML
<current_observation><credit>Weather Underground NOAA Weather Station</credit><credit_URL>http://wunderground.com/</credit_URL><termsofservice link="http://www.wunderground.com/weather/api/d/terms.html">This feed will be deprecated. Please switch to http://www.wunderground.com/weather/api/</termsofservice><image><url>http://icons-ak.wxug.com/graphics/wu2/logo_130x80.png</url><title>Weather Underground</title><link>http://wunderground.com/</link></image><display_location>  <full>San Francisco International, CA</full><city>San Francisco International</city><state>CA</state><state_name>California</state_name><country>US</country><country_iso3166>US</country_iso3166><zip>94128</zip><latitude>37.61888885</latitude><longitude>-122.37472534</longitude><elevation>3.00000000 ft</elevation></display_location><station_id>KSFO</station_id><observation_time>Last Updated on October 6, 3:56 PM PDT</observation_time><observation_time_rfc822>Sat, 06 Oct 2012 22:56:00 GMT</observation_time_rfc822><observation_epoch>1349564160</observation_epoch><local_time>October 6, 4:02 PM PDT</local_time><local_time_rfc822>Sat, 06 Oct 2012 23:02:59 GMT</local_time_rfc822><local_epoch>1349564579</local_epoch><weather>Scattered Clouds</weather><temperature_string>72 F (22 C)</temperature_string><temp_f>72</temp_f><temp_c>22</temp_c><relative_humidity>40%</relative_humidity><icons><icon_set name="Default"><icon_url>http://icons-ak.wxug.com/i/c/a/partlycloudy.gif</icon_url></icon_set><icon_set name="Smiley"><icon_url>http://icons-ak.wxug.com/i/c/b/partlycloudy.gif</icon_url></icon_set><icon_set name="Generic"><icon_url>http://icons-ak.wxug.com/i/c/c/partlycloudy.gif</icon_url></icon_set></icons><icon_url_base>http://icons-ak.wxug.com/graphics/conds/</icon_url_base><icon_url_name>.GIF</icon_url_name><icon>partlycloudy</icon><forecast_url>http://www.wunderground.com/US/CA/San_Francisco_International.html</forecast_url></current_observation>
    XML
    
    parsed_hash_first_pass = WeatherVane::XmlReader.parse(abridged_wunderground_xml)
    
    generated_xml = WeatherVane::XmlWriter.xml(parsed_hash_first_pass)
    
    parsed_hash_second_pass = WeatherVane::XmlReader.parse(generated_xml)
    
    parsed_hash_first_pass.should == parsed_hash_second_pass
  end
end