module Waw
  module Validation
    
    # Validation for a parameter to be an e-mail
    EMAIL = /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
    
  end # module Validation
end # module Waw

class Regexp
  # Waw validation method for regular expressions
  def waw_action_validate(value)
    [value, self =~ value]
  end
end # class Regexp

