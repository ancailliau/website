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
    
  end
end