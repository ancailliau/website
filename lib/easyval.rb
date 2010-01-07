require 'easyval/validator'
require 'easyval/size_validations'
require 'easyval/array_validations'
#
# Provides a reusable architecture for parameter validation 
#
module EasyVal
  
  # Version of EasyValidation
  VERSION = "0.0.1".freeze
  
  # Validator for mandatory values
  Mandatory = EasyVal::Validator.new {|value| not(value.nil?)}
  
  # Validators about size
  Size = EasyVal::SizeValidations.new

  # Validators about size
  Array = EasyVal::ArrayValidations.new

  # Builds a validator with a given block as validation code
  def self.validator(&block)
    EasyVal::Validator.new &block
  end

end