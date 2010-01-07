require 'easyval'
require 'test/unit'
module EasyVal
  class SignatureTest < Test::Unit::TestCase
    
    def test_simple_case
      signature = Signature.new do 
        validation :name, EasyVal::Mandatory, :missing_name
      end
      assert_equal [false, [:missing_name]], signature.apply(:name => nil)
      assert_equal [true, {:name => "blambeau"}], signature.apply(:name => "blambeau")
    end
    
    def test_supports_multiple_rules
      signature = Signature.new do 
        validation :name, EasyVal::Mandatory, :missing_name
        validation :age, (EasyVal::Mandatory & EasyVal.validator{|v| v>18}), :bad_age
      end
      assert_equal [false, [:missing_name, :bad_age]], signature.apply(:name => nil)
      assert_equal [false, [:bad_age]], signature.apply(:name => "blambeau", :age => nil)
      assert_equal [true, {:name => "blambeau", :age => 20}], signature.apply(:name => "blambeau", :age => 20)
    end
    
    def test_typical_web_scenario
      signature = EasyVal.signature do
        validation :mail, EasyVal::Mail, :bad_email
        validation [:password, :confirm], EasyVal::Equal, :passwords_dont_match
        validation :age, EasyVal::Missing | (EasyVal::Integer & (EasyVal.is >= 18)), :bad_age
      end
    
      ok, values = signature.apply(:mail => "blambeau@gmail.com", :password => "pass", :confirm => "pass", :age => 29)
      assert_equal({:mail => "blambeau@gmail.com", :password => "pass", :confirm => "pass", :age => 29}, values)
      assert_equal true, ok
          
      ok, values = signature.apply(:mail => "blambeau@gmail.com", :password => "pass", :confirm => "pass2", :age => 29)
      assert_equal false, ok
      assert_equal [:passwords_dont_match], values
      
      ok, values = signature.apply(:mail => "blambeau@gmail.com", :password => "pass", :confirm => "pass")
      assert_equal({:mail => "blambeau@gmail.com", :password => "pass", :confirm => "pass", :age => nil}, values)
      assert_equal true, ok
          
      ok, values = signature.apply(:mail => "blambeau@gmail.com", :password => "pass", :confirm => "pass", :age => '')
      assert_equal({:mail => "blambeau@gmail.com", :password => "pass", :confirm => "pass", :age => nil}, values)
      assert_equal true, ok
          
      ok, values = signature.apply(:mail => "blambeau@gmail.com", :password => "pass", :confirm => "pass", :age => "19")
      assert_equal({:mail => "blambeau@gmail.com", :password => "pass", :confirm => "pass", :age => 19}, values)
      assert_equal true, ok
    end

    def test_typical_web_scenario_sc2
      signature = EasyVal.signature do
        validation :mail, mail, :bad_email
        validation [:password, :confirm], equal, :passwords_dont_match
        validation :age, missing | (integer & (is >= 18)), :bad_age
        #validation :newsletter, (default(false) | boolean), :bad_newsletter
      end
    
      ok, values = signature.apply(:mail => "blambeau@gmail.com", :password => "pass", :confirm => "pass", :age => 29)
      assert_equal({:mail => "blambeau@gmail.com", :password => "pass", :confirm => "pass", :age => 29}, values)
      assert_equal true, ok
    end
    
  end
end