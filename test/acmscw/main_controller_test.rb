require 'test/unit'
require 'acmscw/main_controller'
module AcmScW
  class MainControllerTest < Test::Unit::TestCase
    
    def test_find_requested_page_file
      assert_equal 'index.wtpl', MainController.find_requested_page_file('/')
      assert_equal 'index.wtpl', MainController.find_requested_page_file('/index')
      assert_equal 'index.wtpl', MainController.find_requested_page_file('/index.html')
      assert_equal 'index.wtpl', MainController.find_requested_page_file('/index.htm')
      assert_equal 'securite-vie-privee/index.wtpl', MainController.find_requested_page_file('/securite-vie-privee/')
      assert_equal 'securite-vie-privee/index.wtpl', MainController.find_requested_page_file('/securite-vie-privee/index')
      assert_equal 'securite-vie-privee/index.wtpl', MainController.find_requested_page_file('/securite-vie-privee/index.html')
      assert_equal 'securite-vie-privee/index.wtpl', MainController.find_requested_page_file('/securite-vie-privee/index.htm')
      assert_equal 'securite-vie-privee/sponsoring.wtpl', MainController.find_requested_page_file('/securite-vie-privee/sponsoring')
    end
    
  end
end
    
