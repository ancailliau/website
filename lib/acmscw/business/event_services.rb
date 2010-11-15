module AcmScW
  module Business
    class EventServices < AcmScW::Business::AbstractServices
      
      # Returns the events relation
      def events
        AcmScW.database[:events]
      end
      
      # Returns a tuple for a given event
      def this_event(id)
        AcmScW.database[:events].filter(:id => id).first
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
      
      # Checks if an event has available places 
      def may_still_register?(id)
        tuple = AcmScW::database[:webr_planned_events].filter(:id => id).first
        tuple and (tuple[:remaining_places].nil? or (tuple[:remaining_places] > 0))
      end
      
      def is_registered?(people, event)
        args = {:event => event, :people => ps.people_id(people)}
        not(AcmScW.database[:event_registrations].filter(args).empty?)
      end
      
      # Register someone to an event
      def register(people, event, additional_params = {})
        # create a default profile if people does not exist
        unless ps.people_exists?(people)
          ps.create_default_profile(people) 
        end
        people = ps.people_id(people)
        
        # insert in the registration table if not already the case
        unless is_registered?(people, event)
          args = {:event => event, :people => people}
          AcmScW.database[:event_registrations].insert(args)
        end
        
        # insert/update additional info if needed
        event_tuple = this_event(event)
        if (table_name = event_tuple[:form_table])
          table_name = table_name.to_sym
          table    = AcmScW.database[table_name]
          columns  = AcmScW.database.schema(table_name).collect{|ary| ary[0]}

          key   = {:event => event, :people => people}
          tuple = additional_params.merge(key).keep(*columns)
          if table.filter(key).empty?
            table.insert(tuple)
          else
            table.filter(key).update(tuple)
          end
        end
      end
      
      # Unregister to some event
      def unregister(people, event)
        args = {:event => event, :people => ps.people_id(people)}
        AcmScW.database[:event_registrations].filter(args).delete
      end
      
    end # class EventServices
  end # module Business
end # module AcmScW