module Waw
  module Testing
    module Assertions
      
      # Asserts that a mail has been sent
      def assert_mail_sent(to, msg="An e-mail has been sent to #{to}")
        assert AcmScW::Tools::MailServer.mail_has_been_sent?(to), msg
        AcmScW::Tools::MailServer.mail_contents(to)
      end
      
      # Asserts that an account activation e-mail has been sent. When passes, 
      # returns [href, activation_key].
      def assert_activation_mail_sent(to, msg="An activation e-mail has been sent to #{to}")
        assert_mail_sent(to, msg)
        mail_contents = AcmScW::Tools::MailServer.mail_contents(to)
        found = has_tag?("a", {:href => ".*?activate_account.*?"}, mail_contents)
        assert found, "#{msg} (activation link not found)"
        if found[:href] =~ /actkey=(.*)$/
          [found[:href], $1]
        else
          assert false, "#{msg} (unable to find activation key)"
        end
      end
      
    end # module Assertions
  end # module Testing
end # module Waw