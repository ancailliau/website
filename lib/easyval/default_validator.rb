module EasyVal
  class DefaultValidator < Validator
    
    def initialize(default_value)
      @default_value = default_value
    end
    
    def validate(*values)
      true
    end
    alias :=== :validate
    
    def convert_and_validate(*values)
      raise "Default does not support multiple values" if values.size > 1
      value = values[0]
      if EasyVal.is_missing?(value)
        [true, [@default_value]]
      else
        [false, values]
      end
    end
    
  end # class DefaultValidator
end # module EasyVal