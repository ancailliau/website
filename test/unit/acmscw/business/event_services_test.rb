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
            :id => 'test_activity', :name => 'Soirées-conférences à thème', :abstract => <<-EOF
            	<p>Ces conférences à thème ont pour objectif de présenter différents
            	aspects de l'informatique au grand public. Celles-ci ont lieu à la fois en
            	semaine et en soirée afin de permettre au plus grand nombre possible d'y
            	assister. Elles comportent plusieurs présentations dont les orateurs sont
            	choisis pour leur capacité à faire partager leur passion ou métier au grand
            	public, cela afin d'assurer la qualité de la conférence.</p>
	
            	<p>Notre première soirée de conférences tourne autours du thème de la
            	sécurité et de la vie privée. <a href="/securite-vie-privee">En savoir 
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
          :date => Time.now,
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