require "acmscw"
require "test/unit"
module AcmScW
  module Tools
    class MailServerTest < Test::Unit::TestCase
      
      # Cleans sent mails
      def setup
        AcmScW::Tools::MailServer.clean("no-reply@acm-sc.be", "news@acm-sc.be")
      end
      
      def test_send_mail
        assert_equal false, AcmScW::Tools::MailServer.mail_has_been_sent?("news@acm-sc.be")
        AcmScW::Tools::MailServer.send_mail("Hello", "no-reply@acm-sc.be", "news@acm-sc.be")
        assert_equal true, AcmScW::Tools::MailServer.mail_has_been_sent?("news@acm-sc.be")
        assert_equal "Hello", AcmScW::Tools::MailServer.mail_contents("news@acm-sc.be")
      end
      
    end
  end
end