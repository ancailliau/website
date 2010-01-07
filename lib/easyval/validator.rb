module EasyVal
  
  #
  # A validator reusable class.
  #
  class Validator
    
    # Creates a validator instance that takes a block as validation code
    def initialize(&block)
      raise ArgumentError, "Missing validation block" if block.nil?
      @block = block
    end

    # Calls the block installed at initialization time    
    def validate(*values)
      @block.call(*values)
    end
    alias :=== :validate
    
    # Negates this validator
    def not
      Validator.new {|value| !self.validate(value)}
    end
    
    # Creates a validator by disjunction
    def |(validator)
      Validator.new {|*args| self.validate(*args) or validator.validate(*args)}
    end
    
    # Creates a validator by conjunction
    def &(validator)
      Validator.new {|*args| self.validate(*args) and validator.validate(*args)}
    end
    
  end # class Validator
end # module EasyVal