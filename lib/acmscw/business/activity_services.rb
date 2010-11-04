module AcmScW
  module Business
    class ActivityServices < AcmScW::Business::AbstractServices
      
      # Returns people_services
      def people_services
        @people_services ||= Waw.resources.business.people
      end
      alias :ps :people_services

      # Returns the activity relation
      def activities
        AcmScW.database[:activities]
      end
      
      # Creates an activity
      def create_activity(tuple)
        AcmScW.database[:activities].insert(tuple)
      end
      
      # Update an activity
      def update_activity(tuple)
        AcmScW.database[:activities].filter(:id => tuple[:id]).update(tuple)
      end
      
      # Delete an activity
      def delete_activity(tuple)
        AcmScW.database[:activities].filter(:id => tuple[:id]).delete
      end         
          
      # Checks if an activity exists?
      def has_activity?(id)
        not(activities.filter(:id => id).empty?)
      end
      alias :activity_exists? :has_activity?
      
      ########################################################################## Responsibilities

      def has_responsibility?(people, activity)
        args = {:activity => activity, :people => ps.people_id(people)}
        not(AcmScW.database[:activity_responsabilities].filter(args).empty?)
      end
      
      def give_responsibility(people, activity)
        return if has_responsibility?(people, activity)
        return if not ps.people_exists?(people)
        args = {:activity => activity, :people => ps.people_id(people), :kind => "Responsable", :order => 0}
        AcmScW.database[:activity_responsabilities].insert(args)
      end

      def remove_responsibility(people, activity)
        args = {:activity => activity, :people => ps.people_id(people)}
        AcmScW.database[:activity_responsabilities].filter(args).delete
      end

      
    end # class ActivityServices
  end # module Business
end # module AcmScW
