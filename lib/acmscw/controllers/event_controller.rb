module AcmScW
  module Controllers
    #
    # Defines the controller for events
    #
    class EventController < ::Waw::ActionController
    
      # Encapsulate all actions through a database transaction
      def encapsulate(action, actual_params, &block)
        AcmScW.transaction(&block)
      end
    
      # Returns people_services
      def event_services
        @event_services ||= Waw.resources.business.event
      end
    
      ### Login and logout ###########################################################
    
      # Login
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
      
      # Register to an event
      signature {
        validation :event, logged, :user_must_be_logged
        validation :event, event_exists, :unknown_event
      } 
      routing { upon '*' do refresh end }
      def register_to_this_event(params)
        event_services.register(Waw.session_get(:user), params[:event])
        :ok
      end
      
      # Unregister to an event
      signature {
        validation :event, logged, :user_must_be_logged
        validation :event, event_exists, :unknown_event
      } 
      routing { upon '*' do refresh end }
      def unregister_to_this_event(params)
        event_services.unregister(Waw.session_get(:user), params[:event])
        :ok
      end
    
    end # class PeopleController
  end # module Controllers
end # module AcmScW