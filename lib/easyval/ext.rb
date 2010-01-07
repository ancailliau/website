class Module
  
  # Creates a validator from this module
  def to_validator
    ::EasyVal.validator{|s| self===s}
  end
  
end