require 'test/unit'
require 'acmscw/main_controller'
module AcmScW
  class MainControllerTest < Test::Unit::TestCase
    
    def test_find_requested_page_file
      assert_equal 'index.wtpl', MainController.find_requested_page_file('/')
      assert_equal 'securite-vie-privee/index.wtpl', MainController.find_requested_page_file('/securite-vie-privee')
      assert_equal 'securite-vie-privee/sponsoring.wtpl', MainController.find_requested_page_file('/securite-vie-privee/sponsoring')
    end
    
    def test_normalize_req_path
      assert_equal '/', MainController.normalize_req_path('')
      assert_equal '/', MainController.normalize_req_path('/')
      assert_equal '/', MainController.normalize_req_path('/index')
      assert_equal '/', MainController.normalize_req_path('/index.html')
      assert_equal '/', MainController.normalize_req_path('/index.htm')
      assert_equal '/latex', MainController.normalize_req_path('/latex')
      assert_equal '/latex', MainController.normalize_req_path('latex')
      assert_equal '/latex', MainController.normalize_req_path('latex.html')
      assert_equal '/latex', MainController.normalize_req_path('latex.htm')
      assert_equal '/latex', MainController.normalize_req_path('/latex.html')
      assert_equal '/latex', MainController.normalize_req_path('/latex.htm')
      assert_equal '/securite-vie-privee', MainController.normalize_req_path('/securite-vie-privee')
      assert_equal '/securite-vie-privee', MainController.normalize_req_path('/securite-vie-privee/')
      assert_equal '/securite-vie-privee', MainController.normalize_req_path('/securite-vie-privee/index')
      assert_equal '/securite-vie-privee', MainController.normalize_req_path('/securite-vie-privee/index.html')
      assert_equal '/securite-vie-privee', MainController.normalize_req_path('/securite-vie-privee/index.htm')
      assert_equal '/securite-vie-privee/sponsoring', MainController.normalize_req_path('/securite-vie-privee/sponsoring')
      assert_equal '/securite-vie-privee/sponsoring', MainController.normalize_req_path('/securite-vie-privee/sponsoring.html')
      assert_equal '/securite-vie-privee/sponsoring', MainController.normalize_req_path('/securite-vie-privee/sponsoring.htm')
      assert_equal '/securite-vie-privee/sponsoring', MainController.normalize_req_path('/securite-vie-privee/sponsoring/')
      assert_equal '/securite-vie-privee/sponsoring', MainController.normalize_req_path('   /securite-vie-privee/sponsoring/   ')

      assert_equal '/people/activate_account', MainController.normalize_req_path('/people/activate_account')
      assert_equal '/people/activate_account', MainController.normalize_req_path('/people/activate_account?actkey=AAA')
    end
    
  end
end
    
