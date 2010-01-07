module EasyVal
  #
  # A service or data signature, as a list of validations to be respected.
  #
  class Signature
    
    # A validation rule
    class Validation
      
      # Creates a Validation instance
      def initialize(args, validator, onfailure)
        @args = args
        @validator = validator
        @onfailure = onfailure
      end
      
      # Validates argument values given through a hash
      def validate(hash)
        ok = @validator.validate(*@args.collect{|arg| hash[arg]})
        ok ? nil : @onfailure
      end
      
    end # class Validation
    
    # A conversion rule
    class Conversion
      
      # Creates a Convertion rule instance
      def initialize(args, converter, onfailure)
        @args = args
        @converter = converter
        @onfailure = onfailure
      end
      
      # Converts 
      def convert(hash)
        @args.each do |arg|
          converted = @converter.convert(hash[arg])
          if converted
            hash[arg] = converted
          else
            return @onfailure
          end
        end
        nil
      end
      
    end # class Conversion
    
    # Creates an empty signature
    def initialize(&block)
      @conversions = []
      @rules = []
      instance_eval(&block) unless block.nil?
    end
    
    # Adds a conversion rule
    def add_conversion(args, converter, onfailure)
      args = [args] if Symbol===args
      converter = converter.to_converter if Module===converter
      @conversions << Conversion.new(args, converter, onfailure)
    end
    alias :conversion :add_conversion
    
    # Adds a validation rule
    def add_validation(args, validator, onfailure)
      args = [args] if Symbol===args
      @rules << Validation.new(args, validator, onfailure)
    end
    alias :validation :add_validation
    
    # Validates argument values given through a hash and returns a series
    # of onfailure flags.
    def apply(hash)
      converted, failures = hash.dup, []
      failures = @conversions.collect{|c| c.convert(converted)}.compact
      return [false, failures] unless failures.empty?
      failures = @rules.collect{|rule| rule.validate(converted)}.compact
      failures.empty? ? [true, converted] : [false, failures]
    end
    
  end # class Signature
end # module EasyVal