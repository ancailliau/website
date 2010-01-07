module EasyVal
  # Converts values from String to specific domains
  class Converter
    
    # Creates a Converter instance with a block as conversion code
    def initialize(&block)
      raise ArgumentError, "Missing validation block" if block.nil?
      @block = block
    end
    
    # Converts some values to something specific
    def convert(*values)
      @block.call(*values)
    end
    
  end # class Converter
end # module EasyVal