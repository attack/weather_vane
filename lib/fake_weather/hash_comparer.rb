module HashComparer
  def self.valid?(target, source)
    _missing(target, source) == []
  end
  
  def self._missing(target, source)
    source.keys.inject([]) do |memo, key|
      if source[key].kind_of?(Hash)
        if target[key.to_s].kind_of?(Hash)
          next_level = _missing(target[key.to_s], source[key])
          memo << {key => next_level} unless next_level == []
        elsif target[key.to_sym].kind_of?(Hash)
          next_level = _missing(target[key.to_sym], source[key])
          memo << {key => next_level} unless next_level == []
        else
          next_level = _missing({}, source[key])
          memo << {key => next_level} unless next_level == []
        end
      else
        unless (target.has_key?(key.to_s) && !target[key.to_s].kind_of?(Hash)) ||
          (target.has_key?(key.to_sym) && !target[key.to_sym].kind_of?(Hash))
          memo << key
        end
      end
      memo
    end
  end
end

