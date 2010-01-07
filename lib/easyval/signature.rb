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
    
    # Creates an empty signature
    def initialize(&block)
      @conversions = []
      @rules = []
      instance_eval(&block) unless block.nil?
    end
    
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
      failures = @rules.collect{|rule| rule.validate(converted)}.compact
      failures.empty? ? [true, converted] : [false, failures]
    end
    
  end # class Signature
end # module EasyVal