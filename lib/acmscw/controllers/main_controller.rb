module AcmScW
  module Controllers
    class MainController < ::Waw::ActionController
      
      # Returns an instance to the MainServies business layer
      def main_services
        @main_services ||= Waw.resources.business.main
      end
      
      signature {
        validation :mail, mail,                 :invalid_email
        validation :subject, String & mandatory, :missing_subject
        validation :message, String & mandatory, :missing_message
      }
      routing {
        upon 'success/ok'    do redirect(:url => '/feedback?mkey=contact_ok') end
        upon 'validation-ko' do form_validation_feedback                      end
      }
      def send_message(params)
        from, subject, message = params[:mail], params[:subject], params[:message]
        main_services.send_contact_mail(from, subject, message)
      end
      
    end # class MainController
  end # module Controllers
end # module AcmScW
