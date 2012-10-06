require 'nokogiri'
require 'nori'

module WeatherVane
  module XmlReader
    Nori.parser = :nokogiri

    def self.parse(xml)
      Nori.parse(xml)
    end
  end
end