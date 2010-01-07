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
    
    def test_supports_conversions
      signature = Signature.new do 
        conversion :age, Integer, :bad_age
        validation :age, (EasyVal::Mandatory & EasyVal.validator{|v| v>18}), :less_than_18
      end
      assert_equal [false, [:bad_age]], signature.apply(:age => "blambeau")
      assert_equal [false, [:less_than_18]], signature.apply(:age => "12")
      assert_equal [true, {:age => 20}], signature.apply(:age => "20")
    end
    
  end
end