module WeatherVane
  module HashAttribute
    class << self
      def convert(input_hash)
        input_hash.reduce({}) do |output_hash, key_value|
          key, value = key_value
          
          case value
          when Hash
            values, attributes = _partition_hash(value)
            _push_values!(output_hash, key, values)
            _push_attributes!(output_hash, key, attributes)
            
          when Array
            values, attributes = _partition_array(value)
            _push_values!(output_hash, key, values)
            _push_attributes!(output_hash, key, attributes)
            
          else    
            _push_values!(output_hash, key, value)
          end
        end
      end
      
      def _partition_hash(input_hash)
        values = input_hash.select {|key, value| !key.match /^\@/ }
        attributes = input_hash.select {|key, value| key.match /^\@/ }
        
        [values, attributes]
      end
      
      def _partition_array(input_array)
        input_array.reduce([[], {}]) do |collection, row|
          row_values, row_attributes = _partition_hash(row)
          
          collection.first << row_values
          _collect_attributes(collection.last, row_attributes)
          
          collection
        end
      end
      
      private
      
      def _collect_attributes(attributes, new_attributes)
        new_attributes.each do |attr_key, attr_value|
          _push_to_key(attributes, attr_key, attr_value)
        end
        
        attributes
      end
      
      def _push_values!(hash, key, values)
        case values
        when Array
          values.each { |value| _push_to_key(hash, key, convert(value)) }
        when Hash
          hash.merge!({ key => convert(values) })
        else
          hash.merge!({ key => values })
        end
        
        hash
      end
      
      def _push_attributes!(hash, key, attributes)
        attributes_hash = { key => _remove_ampersands(attributes) }
        
        if attributes.any?
          _merge_attributes!(hash, attributes_hash)
        end
        
        hash
      end
      
      def _remove_ampersands(input_hash)
        input_hash.reduce({}) do |output_hash, key_value|
          key, value = key_value
          output_hash.merge({ _remove_ampersand(key) => value })
        end
      end
      
      def _remove_ampersand(input_key)
        input_key.to_s.gsub(/^\@/, '')
      end
      
      def _push_to_key(hash, key, value)
        if hash.has_key?(key)
          unless hash[key].is_a?(Array)
            hash.merge!({ key => [hash[key]] })
          end
          hash[key] << value
        else
          hash.merge!({ key => value })
        end
      end
      
      def _merge_attributes!(hash, value)
        if hash.has_key?(:attributes!)
          hash[:attributes!].merge!(value)
        else
          hash[:attributes!] = value
        end
      end
    end
  end
end