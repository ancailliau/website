module AcmScW
  module Business
    class AbstractServices
    
      # Returns the mail agent from Waw resources.
      # A default one is created for testing purposes.
      def get_mail_agent
        if Waw.resources.nil?
          ::Waw::Tools::Mail::MailAgent.new
        else
          Waw.resources.business.mail_agent
        end 
      end
    
    end # class AbstractServices
  end # module Business
end # module AcmScW