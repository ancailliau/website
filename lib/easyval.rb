require 'easyval/validator'
require 'easyval/and_validator'
require 'easyval/or_validator'
require 'easyval/size_validations'
require 'easyval/array_validations'
require 'easyval/missing_validator'
require 'easyval/ext'
require 'easyval/signature'
#
# Provides a reusable architecture for parameter validation 
#
module EasyVal
  
  # Version of EasyValidation
  VERSION = "0.0.1".freeze
  
  # Builds a validator with a given block as validation code
  def self.validator(&block)
    EasyVal::Validator.new &block
  end

  # Builds a signature with a given block as definition
  def self.signature(&block)
    EasyVal::Signature.new &block
  end

  # Builds a validator for less-than-or-equal-to
  def self.<=(value)
    validator{|val| val <= value}
  end

  # Builds a validator for less-than
  def self.<(value)
    validator{|val| val < value}
  end

  # Builds a validator for greater-than-or-equal-to
  def self.>=(value)
    validator{|val| val >= value}
  end

  # Builds a validator for greater-than
  def self.>(value)
    validator{|val| val > value}
  end

  # Validator for mandatory values
  Mandatory = EasyVal::Validator.new {|*values| values.all?{|v| not(v.nil?)}}
  
  # Validator/Converter for missing values
  Missing = EasyVal::MissingValidator.new
  
  # Validator for a mail adress
  Mail = /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/.to_validator

  # Alls passed arguments are equal
  Equal = EasyVal.validator{|*args| args.uniq.size==1}

  # Validators about size
  Size = EasyVal::SizeValidations.new

  # Validators about size
  Array = EasyVal::ArrayValidations.new

end