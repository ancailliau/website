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
    def validate(value)
      @block.call(value)
    end
    alias :=== :validate
    
    # Negates this validator
    def not
      Validator.new {|value| !self.validate(value)}
    end
    
  end # class Validator
end # module EasyVal