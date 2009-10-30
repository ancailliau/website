module Waw
  module Validation
    
    # Validation for a parameter to be an e-mail
    EMAIL = /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
    
    # Validation for a mandatory parameter
    MANDATORY = Kernel.lambda do |value|
      [value, !value.nil? && value != '']
    end
    
  end # module Validation
end # module Waw

class Regexp
  # Waw validation method for regular expressions
  def waw_action_validate(value)
    [value, self =~ value]
  end
end # class Regexp

