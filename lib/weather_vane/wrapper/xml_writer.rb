require 'gyoku'

module WeatherVane
  module XmlWriter
    Gyoku.convert_symbols_to :none
    
    def self.xml(hash)
      converted_hash = WeatherVane::HashAttribute.convert(hash)
      Gyoku.xml(converted_hash)
    end
  end
end