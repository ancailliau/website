module AcmScW
  module Business
    class EventServices < AcmScW::Business::AbstractServices
      
      # Returns the events relation
      def events
        AcmScW.database[:events]
      end
      
      # Creates an event
      def create_event(tuple)
        AcmScW.database[:events].insert(tuple)
      end
      
      # Creates an event
      def update_event(tuple)
        AcmScW.database[:events].filter(:id => tuple[:id]).update(tuple)
      end
      
      # Returns people_services
      def people_services
        @people_services ||= Waw.resources.business.people
      end
      alias :ps :people_services
    
      # Checks if an event exists?
      def has_event?(id)
        not(events.filter(:id => id).empty?)
      end
      alias :event_exists? :has_event?
      
      def is_registered?(people, event)
        args = {:event => event, :people => ps.people_id(people)}
        not(AcmScW.database[:event_registrations].filter(args).empty?)
      end
      
      # Register someone to an event
      def register(people, event)
        return if is_registered?(people, event)
        ps.create_default_profile(people) unless ps.people_exists?(people)
        args = {:event => event, :people => ps.people_id(people)}
        AcmScW.database[:event_registrations].insert(args)
      end
      
      # Unregister to some event
      def unregister(people, event)
        args = {:event => event, :people => ps.people_id(people)}
        AcmScW.database[:event_registrations].filter(args).delete
      end
      
    end # class EventServices
  end # module Business
end # module AcmScW