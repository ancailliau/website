require 'test/unit'
require 'acmscw'
class AcmScWTest < Test::Unit::TestCase
  
  def setup
    AcmScW.unload if AcmScW.loaded?
  end
  
  def test_load_configuration
    AcmScW.load_configuration <<-EOF
      database_user 'acmscw'
      database_port 5432
    EOF
    assert_equal true, AcmScW.respond_to?(:database_user)
    assert_equal true, AcmScW.respond_to?(:database_port)
    assert_equal 'acmscw', AcmScW.database_user
    assert_equal 5432, AcmScW.database_port
  end
  
  def say_hello
    true
  end
  
  def test_and_assumption
    assert_equal :ok, (say_hello and :ok)
  end
  
end