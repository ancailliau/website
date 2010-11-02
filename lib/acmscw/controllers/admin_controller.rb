module AcmScW
  module Controllers
    class AdminController < ::Waw::ActionController

      # Encapsulate all actions through a database transaction
      def encapsulate(action, actual_params, &block)
        AcmScW.transaction(&block)
      end
    
      
      signature {
        validation :id, is_admin, :must_be_admin
        validation :short, mandatory, :invalid_short_url
        validation :long, mandatory,  :invalid_long_url
      }
      routing {
        upon 'validation-ko' do form_validation_feedback                     end
        upon 'success/ok'    do message('/admin/main/add-url-rewriting-ok')  end
      }
      def add_url_rewriting(params)
        AcmScW::database[:url_rewriting].insert(params.keep(:short, :long))
        :ok
      end
      
      signature {
        validation :short, mandatory, :invalid_short_url
        validation :id, is_admin, :must_be_admin
      }
      routing {
        upon 'validation-ko' do message('/admin/main/rm-url-rewriting-ko')  end
        upon 'success/ok'    do message('/admin/main/rm-url-rewriting-ok')  end
      }
      def rm_url_rewriting(params)
        AcmScW::database[:url_rewriting].filter(params.keep(:short)).delete()
        :ok
      end
      
    end # class AdminController
  end # module Controllers
end # module AcmScW