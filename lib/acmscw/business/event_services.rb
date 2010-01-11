module AcmScW
  module Business
    class EventServices
      
      # Returns people_services
      def people_services
        @people_services ||= Waw.resources.business.people
      end
      alias :ps :people_services
    
      
      # Register someone to an event
      def register(people, event)
        ps.create_default_profile(people) unless ps.people_exists?(people)
        args = {:event => event, :people => ps.people_id(people)}
        AcmScW.database[:event_registrations].insert(args)
      end
      
    end # class EventServices
  end # module Business
end # module AcmScW