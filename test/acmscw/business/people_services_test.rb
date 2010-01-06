require 'test/unit'
require 'acmscw/business/business_services_test'
require 'acmscw'
module AcmScW
  module Business
    class PeopleServicesTest < BusinessServicesTest
      
      TEST_USER = "testuser@uclouvain.acm-sc.be"
      
      # Forces the test user to disapear 
      def setup
        @layer = AcmScW::Business::PeopleServices.instance 
        @layer.drop_people(TEST_USER)
      end
      
      def test_user_exists?
        @layer.people.limit(10).each do |t|
          assert_equal true, @layer.people_exists?(t[:id])
          assert_equal true, @layer.people_exists?(t[:mail])
        end
        assert_equal false, @layer.people_exists?(@layer.people.max(:id)+1)
      end
      
      # Test creating a default profile
      def test_create_default_profile
        assert_equal false, @layer.people_exists?(TEST_USER)
        @layer.create_default_profile(TEST_USER)
        assert_equal true, @layer.people_exists?(TEST_USER)
        assert_equal false, @layer.subscribed_to_newsletter?(TEST_USER)
        @layer.subscribe_to_newsletter(TEST_USER)
        assert_equal true, @layer.subscribed_to_newsletter?(TEST_USER)
      end
      
      def test_subscribe_on_unexisting_user
        @layer.subscribe_to_newsletter(TEST_USER)
        assert_equal true, @layer.people_exists?(TEST_USER)
        assert_equal true, @layer.subscribed_to_newsletter?(TEST_USER)
      end
      
    end
  end
end