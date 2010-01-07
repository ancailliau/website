require 'test/unit'
require 'acmscw/business/business_services_test'
require 'acmscw'
module AcmScW
  module Business
    class PeopleServicesTest < BusinessServicesTest
      
      TEST_USER = "testuser@uclouvain.acm-sc.be"
      TEST_USER_ALIAS = "testuser2@uclouvain.acm-sc.be"
      
      # Forces the test user to disapear 
      def setup
        @layer = AcmScW::Business::PeopleServices.instance 
        @layer.drop_people(TEST_USER)
        @layer.drop_people(TEST_USER_ALIAS)
        AcmScW::Tools::MailServer.clean(TEST_USER)
        AcmScW::Tools::MailServer.clean(TEST_USER_ALIAS)
      end
      
      def test_user_exists?
        @layer.people.limit(10).each do |t|
          assert_equal true, @layer.people_exists?(t[:id])
          assert_equal true, @layer.people_exists?(t[:mail])
        end
        max = (@layer.people.max(:id) || 0)
        assert_equal false, @layer.people_exists?(max+1)
      end
      
      # Test creating a default profile
      def test_create_default_profile
        assert_equal false, @layer.people_exists?(TEST_USER)
        @layer.create_default_profile(TEST_USER)
        assert_equal true, @layer.people_exists?(TEST_USER)
        assert_equal false, @layer.subscribed_to_newsletter?(TEST_USER)
        assert_equal false, @layer.account_activated?(TEST_USER)
        assert_equal true, @layer.account_waits_activation?(TEST_USER)
        assert_equal true, AcmScW::Tools::MailServer.mail_has_been_sent?(TEST_USER)
        @layer.subscribe_to_newsletter(TEST_USER)
        assert_equal true, @layer.subscribed_to_newsletter?(TEST_USER)
      end
      
      def test_subscribe_on_unexisting_user
        @layer.subscribe_to_newsletter(TEST_USER)
        assert_equal true, @layer.people_exists?(TEST_USER)
        assert_equal true, @layer.subscribed_to_newsletter?(TEST_USER)
        assert_equal false, @layer.account_activated?(TEST_USER)
        assert_equal true, @layer.account_waits_activation?(TEST_USER)
        assert_equal true, AcmScW::Tools::MailServer.mail_has_been_sent?(TEST_USER)
      end
      
      def test_subscribe_on_existing_user
        assert_equal false, @layer.people_exists?(TEST_USER)
        @layer.create_default_profile(TEST_USER)
        assert_equal true, @layer.people_exists?(TEST_USER)
        assert_equal true, AcmScW::Tools::MailServer.mail_has_been_sent?(TEST_USER)
        AcmScW::Tools::MailServer.clean(TEST_USER)
        @layer.subscribe_to_newsletter(TEST_USER)
        assert_equal false, AcmScW::Tools::MailServer.mail_has_been_sent?(TEST_USER)
      end
      
      def test_activation_key
        assert_not_nil @layer.activation_key("blambeau@gmail.com")
      end
      
      def test_account_activation_sc1
        assert_not_nil(activation_key = @layer.create_default_profile(TEST_USER))
        assert_equal false, @layer.account_activated?(TEST_USER)
        assert_equal true, @layer.account_waits_activation?(TEST_USER)
        assert_equal false, @layer.people_may_log?(TEST_USER)
        assert_equal true, AcmScW::Tools::MailServer.mail_has_been_sent?(TEST_USER)
        @layer.activate(activation_key)
        assert_equal true, @layer.account_activated?(TEST_USER)
        assert_equal false, @layer.account_waits_activation?(TEST_USER)
        assert_nil @layer.this_people(TEST_USER).first[:activation_key]
        assert_equal false, @layer.people_may_log?(TEST_USER)
        assert_equal false, @layer.people_may_log?(TEST_USER, 'withapassword')
      end
      
      def test_account_activation_sc2
        assert_not_nil(activation_key = @layer.create_default_profile(TEST_USER))
        assert_equal false, @layer.account_activated?(TEST_USER)
        assert_equal true, @layer.account_waits_activation?(TEST_USER)
        assert_equal false, @layer.people_may_log?(TEST_USER)
        assert_equal true, AcmScW::Tools::MailServer.mail_has_been_sent?(TEST_USER)
        @layer.activate(activation_key, :password => 'thepassword')
        assert_equal true, @layer.account_activated?(TEST_USER)
        assert_equal false, @layer.account_waits_activation?(TEST_USER)
        assert_nil @layer.this_people(TEST_USER).first[:activation_key]
        assert_equal true, @layer.people_may_log?(TEST_USER)
        assert_equal true, @layer.people_may_log?(TEST_USER, 'thepassword')
        assert_equal false, @layer.people_may_log?(TEST_USER, 'notthepassword')
      end
      
      def test_modifying_mail_leads_to_new_activation
        assert_not_nil(activation_key = @layer.create_default_profile(TEST_USER))
        @layer.activate(activation_key, :password => 'thepassword')
        assert_equal true, @layer.people_may_log?(TEST_USER)
        assert_equal :ok, @layer.update_profile(TEST_USER, :password => 'newpass')
        assert_equal true, @layer.people_may_log?(TEST_USER)
        assert_equal true, AcmScW::Tools::MailServer.mail_has_been_sent?(TEST_USER)
        assert_equal :activation_required, @layer.update_profile(TEST_USER, :mail => TEST_USER_ALIAS)
        assert_equal false, @layer.people_may_log?(TEST_USER)
        assert_equal false, @layer.people_may_log?(TEST_USER_ALIAS)
        assert_equal false, @layer.account_activated?(TEST_USER_ALIAS)
        assert_equal true, @layer.account_waits_activation?(TEST_USER_ALIAS)
        assert_equal true, AcmScW::Tools::MailServer.mail_has_been_sent?(TEST_USER_ALIAS)
      end
      
    end
  end
end