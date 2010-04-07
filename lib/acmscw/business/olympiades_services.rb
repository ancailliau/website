module AcmScW
  module Business
    class OlympiadesServices < AcmScW::Business::AbstractServices
      
      # Returns the mail agent to use
      def mail_agent
        unless @mail_agent
          @mail_agent = get_mail_agent
          template = @mail_agent.add_template(:olympiades_results_announce)
          template.from         = "UCLouvain ACM Student Chapter <no-reply@uclouvain.acm-sc.be>"
          template.subject      = "Vos résultats aux olympiades"
          template.content_type = 'text/html'
          template.charset      = 'UTF-8'
          template.body         = File.read(File.join(File.dirname(__FILE__), 'olympiades_results_announce.wtpl'))
        end
        @mail_agent
      end
      
      # Sends an email to participant with URL to their points
      def send_results_announce_mail
        Waw.resources.model.olympiades_results.each do |people|
          mail, sid = people[:mail], people[:sid]
          context = {:url => Waw.config.web_base + "olympiades/results/show/#{sid}"}
          mail_agent.send_mail(:olympiades_results_announce, context, mail)
        end
      end
      
    end # class OlympiadesServices
  end # module Business
end # module AcmScW