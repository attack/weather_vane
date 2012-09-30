require 'net/http'
require 'uri'
require 'nori'

module WeatherVane
  class Service
    def self.http_get(url, params={})
      uri = URI(url)
      
      response = if uri.respond_to?(:encode_www_form)
        uri.query = URI.encode_www_form(params)
        Net::HTTP.get_response(uri)
      else
        path = "#{uri.path}?".concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&'))
        Net::HTTP.get_response(uri.host, path)
      end  
      
      Nori.parse(response.body)
    end
  end
end
