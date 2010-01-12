require 'test/unit'
require 'waw'
class AcmScWTest < Test::Unit::TestCase
  
  def test_waw_project_structure
    Waw::Services::PublicPages::Controller.check_options
  end
  
  def say_hello
    true
  end
  
  def test_and_assumption
    assert_equal :ok, (say_hello and :ok)
  end
  
end