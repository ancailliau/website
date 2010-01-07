module EasyVal
  class MissingValidator < EasyVal::Validator
    
    # Checks if a given value is considered missing
    def is_missing?(value)
      value.nil? or (String===value and value.strip.empty?)
    end
    
    # Calls the block installed at initialization time    
    def validate(*values)
      values.all?{|value| is_missing?(value)}
    end
    alias :=== :validate
    
    # Converts and validate
    def convert_and_validate(*values)
      validate(*values) ? [true, values.collect{|v| nil}] : [false, values]
    end
    
  end # class MissingValidator
end # module EasyVal