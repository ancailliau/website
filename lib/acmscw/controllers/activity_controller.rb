module AcmScW
  module Controllers
    #
    # Defines the controller for events
    #
    class ActivityController < ::Waw::ActionController
    
      ACTIVITY_COLUMNS = [:id, :name, :abstract, :card_path]
    
      # Encapsulate all actions through a database transaction
      def encapsulate(action, actual_params, &block)
        AcmScW.transaction(&block)
      end

      # Returns activity_services
      def activity_services
        @activity_services  ||= Waw.resources.business.activity
      end
    
      # Returns people_services
      def people_services
        @people_services ||= Waw.resources.business.people
      end
    
    
      ######################################################################### Creation and update
    
      ActivityCommonSignature = Waw::Validation.signature {
        validation :id,        mandatory & /^[a-z][a-z0-9\-]+/, :invalid_activity_id
        validation :name,      mandatory,                       :invalid_activity_name
        validation :card_path, mandatory,                       :invalid_activity_card_path
        validation :abstract,  mandatory,                       :invalid_activity_abstract
      }
      
      signature(ActivityCommonSignature) {
        validation [], is_admin, :must_be_admin
      }
      routing {
        upon 'validation-ko' do form_validation_feedback     end
        upon 'success/ok'    do message('/admin/activities/create-ok')  end
      }
      def create(params)
        activity_services.create_activity(params.keep(*ACTIVITY_COLUMNS))
        :ok
      end
    
      signature(ActivityCommonSignature) {
        validation [], is_admin, :must_be_admin
      }
      routing {
        upon 'validation-ko' do form_validation_feedback     end
        upon 'success/ok'    do message('/admin/activities/update-ok')  end
      }
      def update(params)
        activity_services.update_activity(params.keep(*ACTIVITY_COLUMNS))
        :ok
      end
      
      signature() {
        validation [], is_admin, :must_be_admin
        validation :id, mandatory & /^[a-z][a-z0-9\-]+/, :invalid_activity_id
      }
      routing {
        upon 'validation-ko' do form_validation_feedback     end
        upon 'success/ok'    do message('/admin/activities/delete-ok')  end
      }
      def delete(params)
        activity_services.delete_activity(params.keep(*ACTIVITY_COLUMNS))
        :ok
      end


      ######################################################################### Responsabilities
 
      ResponsibleCommonSignature = Waw::Validation.signature {
        validation [], is_admin, :must_be_admin
        validation :id, mandatory & /^[a-z][a-z0-9\-]+/, :invalid_activity_id
        validation :mail, mandatory & mail & user_exists, :unknown_user
      }
    
      signature(ResponsibleCommonSignature) {}
      routing {
        upon 'success/ok'    do message('/admin/activities/give-responsibility-ok') end
        upon 'validation-ko' do form_validation_feedback                            end
      }
      def give_responsibility(params)
        mail = params[:mail]
        activity_services.give_responsibility(mail, params[:id])
        :ok
      end

      signature(ResponsibleCommonSignature) {}
      routing {
        upon 'success/ok'    do message('/admin/activities/remove-responsibility-ok') end
        upon 'validation-ko' do form_validation_feedback                              end
      }
      def remove_responsibility(params)
        mail = params[:mail]
        activity_services.remove_responsibility(mail, params[:id])
        :ok
      end
      
    end # class ActivityController
  end # module Controllers
end # module AcmScW
