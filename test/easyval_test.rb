require 'easyval'
require 'test/unit'
module EasyVal
  class EasyValTest < Test::Unit::TestCase
    
    def test_historical_first
      assert EasyVal::Mandatory===false, "EasyVal::Mandatory===false"
      assert EasyVal::Mandatory===true, "EasyVal::Mandatory===true"
      assert EasyVal::Mandatory==="", "EasyVal::Mandatory==="""
      assert EasyVal::Mandatory===0, "EasyVal::Mandatory===0"
      assert EasyVal::Mandatory===1, "EasyVal::Mandatory===1"
      assert EasyVal::Mandatory.not===nil, "EasyVal::Mandatory.not===nil"

      assert (EasyVal::Size > 0)==="12", "(EasyVal::Size > 0)==='12'"
      assert (EasyVal::Size > 0).not==="", "(EasyVal::Size > 0).not==="
      assert (EasyVal::Size >= 0)==="12", "(EasyVal::Size >= 0)==='12'"
      assert (EasyVal::Size >= 0)==="", "(EasyVal::Size >= 0)==="

      assert (EasyVal::Size > 0)===[:hello], "(EasyVal::Size > 0)===[:hello]"
      assert (EasyVal::Size > 0).not===[], "(EasyVal::Size > 0).not===[]"

      assert (EasyVal::Size == 0)===[]
      assert !((EasyVal::Size == 10)===[])

      assert EasyVal::Array[String] === []
      assert EasyVal::Array[String] === ["coucou", "hello"]
      assert !(EasyVal::Array[String] === [12])
      assert !(EasyVal::Array[String] === ["coucou", 12])
      assert EasyVal::Array[EasyVal::Size>2] === ["coucou", "hello"]
      assert !(EasyVal::Array[EasyVal::Size>2] === ["coucou", "h"])
    end
    
    def test_equal
      assert_equal true, EasyVal::Equal.validate(1, 1, 1, 1)
      assert_equal false, EasyVal::Equal.validate(1, 1, 1, false)
      assert_equal true, EasyVal::Equal.validate("pass", "pass")
      assert_equal false, EasyVal::Equal.validate("pass", "pass2")
    end
    
    def test_validator
      validator = EasyVal.validator{|val| Integer===val and val>10}
      assert_equal true, validator===11
      assert_equal false, validator===10
      assert_equal false, validator===7
      assert_equal false, validator==="10"
    end
    
    def test_validator_accepts_multiple_arguments
      validator = EasyVal.validator{|val1, val2| val1==val2}
      assert_equal true, validator.validate("hello", "hello")
      assert_equal false, validator.validate("hello", 10)
      assert_equal true, validator.validate(10, 10)
    end
    
    def test_validator_conjunction
      val = (EasyVal::Mandatory & EasyVal.validator{|v| v>10})
      assert_equal true, val===11
      assert_equal false, val===10
      assert_equal false, val===nil
    end
    
    def test_validator_disjunction
      val = (EasyVal::validator{|v| v<10} | EasyVal.validator{|v| v>10})
      assert_equal true, val===11
      assert_equal false, val===10
      assert_equal true, val===9
    end
    
    def test_to_validator_on_module
      assert_equal true, String.to_validator==="blambeau"
      assert_equal false, Integer.to_validator==="blambeau"
      assert_equal true, Integer.to_validator===10
    end
    
    def test_to_validator_on_regexp
      assert_equal true, /[a-z]+/.to_validator==="blambeau"
      assert_equal false, /[a-z]+/.to_validator==="12339"
    end
    
    # def test_typical_web_scenario
    #   signature = EasyVal.signature do
    #     validation :mail, EasyVal::Mail, :bad_email
    #     validation [:password, :confirm], EasyVal::Equal, :passwords_dont_match
    #     validation :age, EasyVal::Missing | (Integer & (EasyVal >= 18)), :bad_age
    #   end
    # 
    #   ok, values = signature.apply(:mail => "blambeau@gmail.com", :password => "pass", :confirm => "pass", :age => "29")
    #   assert_equal true, ok
    #   assert_equal({:mail => "blambeau@gmail.com", :password => "pass", :confirm => "pass", :age => 29}, values)
    # 
    #   ok, values = signature.apply(:mail => "blambeau@gmail.com", :password => "pass", :confirm => "pass2", :age => "29")
    #   assert_equal false, ok
    #   assert_equal [:passwords_dont_match], values
    #   
    #   ok, value = signature.apply(:mail => "blambeau@gmail.com", :password => "pass", :confirm => "pass2")
    #   assert_equal true, ok
    # end
    
  end
end