module AcmScW
  module Controllers
    #
    # Defines the controller for events
    #
    class ActivityController < ::Waw::ActionController
    
      EVENT_COLUMNS = [:id, :name, :abstract, :card_path]
    
      # Encapsulate all actions through a database transaction
      def encapsulate(action, actual_params, &block)
        AcmScW.transaction(&block)
      end

      # Returns activity_services
      def activity_services
        @activity_services  ||= Waw.resources.business.activity
      end
    
      ######################################################################### Creation and update
    
      ActivityCommonSignature = Waw::Validation.signature {
        validation :id, mandatory & /^[a-z][a-z0-9\-]+/, :invalid_activity_id
        validation :name, mandatory, :invalid_activity_name
        validation :card_path, missing, :invalid_activity_card_path
        validation :abstract, mandatory, :invalid_activity_abstract
      }
      signature(ActivityCommonSignature) {
        validation :id, is_admin, :must_be_admin
      }
      routing {
        upon 'validation-ko' do form_validation_feedback     end
        upon 'success/ok'    do message('/admin/activities/create-ok')  end
      }
      def create(params)
        activity_services.create_activity(params.keep(*EVENT_COLUMNS))
        :ok
      end
    
      signature(ActivityCommonSignature) {
        validation :id, is_admin, :must_be_admin
      }
      routing {
        upon 'validation-ko' do form_validation_feedback     end
        upon 'success/ok'    do message('/admin/activities/update-ok')  end
      }
      def update(params)
        activity_services.update_activity(params.keep(*EVENT_COLUMNS))
        :ok
      end
      
      signature() {
        validation :id, mandatory & /^[a-z][a-z0-9\-]+/, :invalid_activity_id
        validation :id, is_admin, :must_be_admin
      }
      routing {
        upon 'validation-ko' do form_validation_feedback     end
        upon 'success/ok'    do message('/admin/activities/delete-ok')  end
      }
      def delete(params)
        activity_services.delete_activity(params.keep(*EVENT_COLUMNS))
        :ok
      end
      
    end # class ActivityController
  end # module Controllers
end # module AcmScW
