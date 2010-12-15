require 'digest/md5'
require 'base64'
module AcmScW
  module Business
    class OrderServices < AcmScW::Business::AbstractServices
      
      # Creates a services layer instance
      def initialize
      end
      
      # Returns the mail agent to use
      def mail_agent
	return false
        unless @mail_agent
          @mail_agent = get_mail_agent
          template = @mail_agent.add_template(:activation)
          template.from         = "UCLouvain ACM Student Chapter <no-reply@acm-sc.be>"
          template.bcc          = ["no-reply@acm-sc.be"]
          template.subject      = "Votre inscription sur uclouvain.acm-sc.be"
          template.content_type = 'text/html'
          template.charset      = 'UTF-8'
          template.body         = File.read(File.join(File.dirname(__FILE__), 'activation_mail.wtpl'))
        end
        @mail_agent
      end
     
      
    end # class OrderServices
  end # module Business
end # module AcmScW
