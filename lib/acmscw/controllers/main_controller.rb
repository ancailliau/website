module AcmScW
  module Controllers
    class MainController < ::Waw::ActionController
      
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
        template = File.join(File.dirname(__FILE__), 'contact_mail.wtpl')
        message = WLang.file_instantiate(template, params.unsymbolize_keys).to_s
        AcmScW::Tools::MailServer.send_mail(message, params[:mail], 'info@uclouvain.acm-sc.be')
        :ok
      end
      
    end # class MainController
  end # module Controllers
end # module AcmScW
