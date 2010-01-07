module EasyVal
  class MissingValidator < EasyVal::Validator
    
    # Calls the block installed at initialization time    
    def validate(*values)
      values.all?{|value| EasyVal.is_missing?(value)}
    end
    alias :=== :validate
    
    # Converts and validate
    def convert_and_validate(*values)
      validate(*values) ? [true, values.collect{|v| nil}] : [false, values]
    end
    
  end # class MissingValidator
end # module EasyVal