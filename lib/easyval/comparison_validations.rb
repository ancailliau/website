module EasyVal
  class ComparisonValidations < EasyVal::Validator
    
    # Builds a validator that verifies that the length is greater than
    # a specified value
    def >(value)
      Validator.new {|val| val > value}
    end
    
    # Builds a validator that verifies that the length is greater-or-equal to
    # a specified value
    def >=(value)
      Validator.new {|val| val >= value}
    end
    
    # Builds a validator that verifies that the length is less than
    # a specified value
    def <(value)
      Validator.new {|val| val < value}
    end
    
    # Builds a validator that verifies that the length is less-or-equal to
    # a specified value
    def <=(value)
      Validator.new {|val| val <= value}
    end
    
    # Builds a validator that verifies that the length is equal to a
    # specified value
    def ==(value)
      Validator.new {|val| val == value}
    end
    
  end # class ComparisonValidations
end # module EasyVal