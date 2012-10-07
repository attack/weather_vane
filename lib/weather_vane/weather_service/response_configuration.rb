module WeatherVane
  class ResponseConfiguration
    attr_writer :response
    
    def response
      @response || {}
    end
  end
end