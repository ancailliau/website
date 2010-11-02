module AcmScW
  module Controllers
    #
    # Defines the controller for events
    #
    class EventController < ::Waw::ActionController
    
      EVENT_COLUMNS = [:id, :activity, :name, :nb_places, :start_time, :end_time, :location, :abstract, :card_path]
    
      # Encapsulate all actions through a database transaction
      def encapsulate(action, actual_params, &block)
        AcmScW.transaction(&block)
      end
    
      # Returns people_services
      def event_services
        @event_services ||= Waw.resources.business.event
      end
    
      EventCommonSignature = Waw::Validation.signature {
        validation :activity, activity_exists, :invalid_event_activity
        validation :id, mandatory & /^[a-z][a-z0-9\-]+/,       :invalid_event_id
        validation :name, mandatory, :invalid_event_name
        validation :nb_places, (integer & (is > 0) | missing), :invalid_event_places
        validation [:start_date, :start_time], datetime(:date_format => '%d/%m/%Y'), :invalid_event_start_time
        validation [:end_date, :end_time], datetime(:date_format => '%d/%m/%Y'), :invalid_event_end_time
        validation :location, mandatory, :invalid_event_location
        validation :card_path, mandatory, :invalid_event_card_path
        validation :abstract, mandatory, :invalid_event_abstract
      }

      signature(EventCommonSignature)
      routing {
        upon 'validation-ko' do form_validation_feedback     end
        upon 'success/ok'    do message('events/create-ok')  end
      }
      def create(params)
        event_services.create_event(params.keep(*EVENT_COLUMNS))
        :ok
      end
    
      signature(EventCommonSignature)
      routing {
        upon 'validation-ko' do form_validation_feedback     end
        upon 'success/ok'    do message('events/update-ok')  end
      }
      def update(params)
        event_services.update_event(params.keep(*EVENT_COLUMNS))
        :ok
      end
    
      ### Login and logout ###########################################################
    
      # Register by email
      signature {
        validation :mail, mandatory & mail, :invalid_email
        validation :event, event_exists, :unknown_event
      }
      routing {
        upon 'success/ok' do feedback(:message => 'event_registration_ok', :hide_input => true) end
        upon '*' do feedback end
      }
      def register_by_mail(params)
        event_services.register(params[:mail], params[:event])
        :ok
      end
      
      # Register when logged
      signature {
        validation :event, logged, :user_must_be_logged
        validation :event, event_exists, :unknown_event
      } 
      routing { upon '*' do refresh end }
      def register_to_this_event(params)
        event_services.register(session.get(:user), params[:event])
        :ok
      end
      
      # Unregister to an event
      signature {
        validation :event, logged, :user_must_be_logged
        validation :event, event_exists, :unknown_event
      } 
      routing { upon '*' do refresh end }
      def unregister_to_this_event(params)
        event_services.unregister(session.get(:user), params[:event])
        :ok
      end
    
    end # class PeopleController
  end # module Controllers
end # module AcmScW