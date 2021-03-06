module AcmScW
  module Controllers
    #
    # Defines the controller for events
    #
    class EventController < ::Waw::ActionController
    
      EVENT_COLUMNS = [:id, :activity, :name, :nb_places, :start_time, :end_time, :location, :abstract, :card_path,
                       :form_url, :form_table]
    
      # Encapsulate all actions through a database transaction
      def encapsulate(action, actual_params, &block)
        AcmScW.transaction(&block)
      end
    
      # Returns people_services
      def people_services
        @people_services ||= Waw.resources.business.people
      end
    
      # Returns event_services
      def event_services
        @event_services  ||= Waw.resources.business.event
      end
    
      ######################################################################### Creation and update
    
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

      signature(EventCommonSignature) {
        validation :id, is_admin, :must_be_admin
      }
      routing {
        upon 'validation-ko' do form_validation_feedback     end
        upon 'success/ok'    do message('/admin/events/create-ok')  end
      }
      def create(params)
        event_services.create_event(params.keep(*EVENT_COLUMNS))
        :ok
      end
    
      signature(EventCommonSignature) {
        validation :id, is_admin, :must_be_admin
      }
      routing {
        upon 'validation-ko' do form_validation_feedback     end
        upon 'success/ok'    do message('/admin/events/update-ok')  end
      }
      def update(params)
        event_services.update_event(params.keep(*EVENT_COLUMNS))
        :ok
      end
    
      ######################################################################### Registration 
      RegistrationCommonSignature = Waw::Validation.signature {
        validation :first_name, mandatory, :invalid_first_name
        validation :last_name,  mandatory, :invalid_last_name
        validation :newsletter, (boolean | default(false)), :bad_newsletter
      }
    
      # Register by email
      signature(RegistrationCommonSignature) {
        validation :mail, mandatory & mail,            :invalid_email
        validation :event, planned_event,              :not_a_planned_event
        validation :event, places_remaining_for_event, :no_remaining_place
      }
      routing {
        upon 'success/ok'                        do formfeed('/events/registration-ok')    end
        upon 'success/already_registred'         do formfeed('/events/already-registered')  end
        upon 'validation-ko'                     do form_validation_feedback                end
        upon 'validation-ko/not_a_planned_event' do formfeed('/events/past-event')          end
        upon 'validation-ko/no_remaining_place'  do formfeed('/events/no-place-remaining')  end
      }
      def register_notlogged(params)
        mail = params[:mail]
        unless people_services.people_exists?(mail)
          people_services.create_default_profile(mail)
          people_services.update_profile(mail, 
            params.keep(:first_name, :last_name, :newsletter)
          )
        end
        if event_services.is_registered?(mail, params[:event])
          :already_registred
        else 
          event_services.register(mail, params[:event], params)
          :ok
        end
      end
      
      # Register when logged
      signature {
        validation :event, logged,                     :user_must_be_logged
        validation :event, planned_event,              :not_a_planned_event
        validation :event, places_remaining_for_event, :no_remaining_place
      } 
      routing { 
        upon 'success/ok'                        do formfeed('/events/registration-ok')    end
        upon 'validation-ko'                     do form_validation_feedback               end
        upon 'validation-ko/not_a_planned_event' do formfeed('/events/past-event')         end
        upon 'validation-ko/no_remaining_place'  do formfeed('/events/no-place-remaining') end
      }
      def register_logged(params)
        unless people_services.looks_complete?(session.get(:user))
          ok, rewrited = RegistrationCommonSignature.apply(params)
          unless ok
            raise(Waw::Validation::KO, rewrited) 
          else
            people_services.update_profile(session.get(:user), 
              params.keep(:first_name, :last_name, :newsletter)
            )
          end
        end
        event_services.register(session.get(:user), params[:event], params)
        :ok
      end
      
      signature {
        validation :event, logged,                     :user_must_be_logged
        validation :event, planned_event,              :not_a_planned_event
        validation :event, places_remaining_for_event, :no_remaining_place
      } 
      routing {
        upon 'success/unregistered'              do formfeed('/events/unregistration-ok')  end
        upon 'success/ok'                        do formfeed('/events/registration-ok')    end
        upon 'validation-ko'                     do form_validation_feedback               end
        upon 'validation-ko/not_a_planned_event' do formfeed('/events/past-event')         end
        upon 'validation-ko/no_remaining_place'  do formfeed('/events/no-place-remaining') end
      }
      def toggle_registration_logged(params)
        people = session.get(:user)
        if event_services.is_registered?(people, params[:event])
          event_services.unregister(people, params[:event])
          :unregistered
        else
          register_logged(params)[1]
        end
      end
      
    end # class PeopleController
  end # module Controllers
end # module AcmScW
