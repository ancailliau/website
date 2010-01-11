require 'test/unit'
require 'acmscw'
module AcmScW
  module Business
    class EventServicesTest < Test::Unit::TestCase
      
      TEST_USER = "testuser@uclouvain.acm-sc.be"

      # Forces the test user to disapear 
      def setup
        @people = AcmScW::Business::PeopleServices.new
        @event = AcmScW::Business::EventServices.new
        @people.drop_people(TEST_USER)
        @people.create_default_profile(TEST_USER)
      end
      
      def test_register
        
      end
      
    end
  end
end