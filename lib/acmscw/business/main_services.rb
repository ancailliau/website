module AcmScW
  module Business
    class MainServices

      # Returns the mail agent to use
      def mail_agent
        unless @mail_agent
          @mail_agent = get_mail_agent
          template = @mail_agent.add_template(:contact)
          template.to           = ["UCLouvain ACM Student Chapter <info@uclouvain.acm-sc.be>"]
          template.subject      = "${subject}"
          template.content_type = 'text/plain'
          template.charset      = 'UTF-8'
          template.body         = "${message}"
        end
        @mail_agent
      end
      
      # May be overrided for testing purposes
      def get_mail_agent
        if Waw.resources.nil?
          ::Waw::Tools::Mail::MailAgent.new
        else
          Waw.resources.business.mail_agent
        end 
      end
      
      # Sends a contact mail to info@uclouvain.acm-sc.be
      def send_contact_mail(from, subject, message)
        mail = mail_agent.to_mail(:contact, {:subject => subject, :message => message})
        mail.from = from
        mail_agent << mail
        :ok
      end
      
    end # class MainServices
  end # module Business
end # module AcmScW