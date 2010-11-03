module AcmScW
  module Business
    class ActivityServices < AcmScW::Business::AbstractServices
      
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
          
      # Checks if an activity exists?
      def has_activity?(id)
        not(activities.filter(:id => id).empty?)
      end
      alias :activity_exists? :has_activity?
      
    end # class ActivityServices
  end # module Business
end # module AcmScW
