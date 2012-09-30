require 'faraday'
require 'nori'
require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'cassettes'
  c.hook_into :faraday
end

module WeatherVane
  class Service
    @@reset = false
    
    def self.http_get(title, url, params={})
      one_day = 24 * 60 * 60      

      response =  VCR.use_cassette(title, :re_record_interval => one_day) do
        force_rerecord!(title, one_day)
        connection = Faraday.new(:url => url) do |faraday|
          faraday.headers['accept-encoding'] = 'none'
          faraday.adapter Faraday.default_adapter
        end
        result = connection.get(nil, params)
        reset_cassette!(title, one_day)
        result
      end
      
      Nori.parse(response.body)
    end
    
    def self.api_valid?
      api_missing == []
    end
    
    def self.allow_next_connection!
      @@reset = true
    end
    
    def self.force_rerecord!(title, interval)
      return unless @@reset
      VCR.eject_cassette
      VCR.insert_cassette(title, :re_record_interval => 0, :record => :all)
    end
    
    def self.reset_cassette!(title, interval)
      return unless @@reset
      @@reset = false
      VCR.eject_cassette
      VCR.insert_cassette(title, :re_record_interval => interval, :record => :none)
    end
  end
end