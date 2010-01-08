require 'easyval/validator'
require 'easyval/not_validator'
require 'easyval/and_validator'
require 'easyval/or_validator'
require 'easyval/comparison_validations'
require 'easyval/size_validations'
require 'easyval/array_validations'
require 'easyval/missing_validator'
require 'easyval/default_validator'
require 'easyval/integer_validator'
require 'easyval/boolean_validator'
require 'easyval/ext'
require 'easyval/signature'
#
# Provides a reusable architecture for parameter validation 
#
module EasyVal
  
  # Version of EasyValidation
  VERSION = "0.0.1".freeze
  
  # Checks if a given value is considered missing
  def self.is_missing?(value)
    value.nil? or (String===value and value.strip.empty?)
  end
    
  # Builds a validator with a given block as validation code
  def self.validator(&block)
    EasyVal::Validator.new &block
  end

  # Builds a signature with a given block as definition
  def self.signature(&block)
    EasyVal::Signature.new &block
  end

  # Validator/Converter for missing values
  Missing = EasyVal::MissingValidator.new
  def self.missing() Missing; end
  
  # Validator for mandatory values
  Mandatory = Missing.not
  def self.mandatory() Mandatory; end
  
  # Default validator
  def self.default(default_value) EasyVal::DefaultValidator.new(default_value); end
  
  # Validator for a mail adress
  Mail = /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/.to_validator
  def self.mail() Mail; end

  WebUrl = /^(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix.to_validator
  def self.weburl() WebUrl; end

  # Alls passed arguments are equal
  Equal = EasyVal.validator{|*args| args.uniq.size==1}
  def self.equal() Equal; end

  # Validators about size
  Size = EasyVal::SizeValidations.new
  def self.size() Size; end

  # Validators about comparisons
  Comparison = EasyVal::ComparisonValidations.new
  def self.is() Comparison; end

  # Validators about size
  Array = EasyVal::ArrayValidations.new
  def self.array() Array; end
  
  # Integer validation
  Integer = EasyVal::IntegerValidator.new
  def self.integer() EasyVal::Integer; end
  
  # Boolean validation
  Boolean = EasyVal::BooleanValidator.new
  def self.boolean() EasyVal::Boolean; end

end