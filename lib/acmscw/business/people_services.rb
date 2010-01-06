require 'singleton'
module AcmScW
  module Business
    class PeopleServices < BusinessServices
      include Singleton
      
      # The poeple relation (through a Sequel Dataset instance)
      attr_reader :people
      
      # Creates a services layer instance
      def initialize
        @people = AcmScW.database[:people]
      end
      
      # Filters the people dataset on a given tuple
      def this_people(id_or_mail)
        people.filter(id_or_mail?(id_or_mail) => id_or_mail)
      end
      
      # Returns the attribute name for a given people identifier
      def id_or_mail?(id_or_mail)
        (/^\d+$/ =~ id_or_mail.to_s) ? :id : :mail
      end
      
      # Drop a given people
      def drop_people(id_or_mail)
        this_people(id_or_mail).delete
      end
      
      # Checks if a given user exists or not
      def people_exists?(id_or_mail)
        not(this_people(id_or_mail).empty?)
      end
      
      # Creates a default profile for a given mail adress
      def create_default_profile(mail)
        people.insert(:mail => mail, :newsletter => false)
      end
      
      # Let someone (un)subscribe to the newsletter
      def subscribe_to_newsletter(mail, yes_or_no=true)
        create_default_profile(mail) unless people_exists?(mail)
        this_people(mail).update(:newsletter => yes_or_no)
      end
      
      # Checks if someone subscribed to the newsletter
      def subscribed_to_newsletter?(id_or_mail)
        this_people(id_or_mail).first[:newsletter]
      end
      
    end # class PeopleServices
  end # module Business
end # module AcmScW