module WeatherVane
  module HashMerger
    def self.deep_merge(original, addition)
      result = original.dup
      addition.each_pair do |k,v|
        tv = result[k]
        result[k] = tv.is_a?(Hash) && v.is_a?(Hash) ? deep_merge(tv, v) : v
      end
      result
    end
  end
end