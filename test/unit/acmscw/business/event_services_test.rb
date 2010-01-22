require 'test/unit'
require 'acmscw'
module AcmScW
  module Business
    class EventServicesTest < Test::Unit::TestCase
      
      TEST_USER = "testuser@uclouvain.acm-sc.be"
      TEST_EVENT = 'test_event'


      # Forces the test user to disapear 
      def setup
        @people = AcmScW::Business::PeopleServices.new
        @event = AcmScW::Business::EventServices.new
        @people.drop_people(TEST_USER)
        @people.create_default_profile(TEST_USER)

        AcmScW.database[:events].filter(:id => TEST_EVENT).delete
        AcmScW.database[:activities].filter(:id => 'test_activity').delete
        AcmScW.database[:activities].insert(
          {
            :id => 'test_activity', :name => 'Soirees-conferences a theme', :abstract => <<-EOF
            	<p>Ces conferences a theme ont pour objectif de presenter differents
            	aspects de l'informatique au grand public. Celles-ci ont lieu a la fois en
            	semaine et en soiree afin de permettre au plus grand nombre possible d'y
            	assister. Elles comportent plusieurs presentations dont les orateurs sont
            	choisis pour leur capacite a faire partager leur passion ou metier au grand
            	public, cela afin d'assurer la qualite de la conference.</p>
	
            	<p>Notre premiere soiree de conferences tourne autours du theme de la
            	securite et de la vie privee. <a href="/securite-vie-privee">En savoir 
            	plus...</a></p>
            EOF
          }
        )
        AcmScW.database[:events].insert(
          :id => TEST_EVENT,
          :activity => 'test_activity',
          :name => '',
          :abstract => '',
          :card_path => '',
          :start_time => Time.now,
          :end_time => Time.now,
          :location => '',
          :formal_location => '',
          :status => 'pending'
        )
      end
      
      def test_register
        @event.register(TEST_USER, TEST_EVENT)
        assert @event.is_registered?(TEST_USER, TEST_EVENT)
      end
      
    end
  end
end