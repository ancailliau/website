TOP = File.join(File.dirname(__FILE__), '..', '..', '..')
$LOAD_PATH.unshift File.join(TOP, 'lib')
require 'acmscw'

# Loads WAW configuration
Waw.load_application(TOP)

# Open a connection to the database, through sequel
database = AcmScW.database

database.transaction do |t|
  # Loads schema of version 1 then 2, then data of version 1
  database << File.read(File.join(File.dirname(__FILE__), 'schema_v1.sql'))
  database << File.read(File.join(File.dirname(__FILE__), 'schema_v2.sql'))
  database << File.read(File.join(File.dirname(__FILE__), 'olympiades.sql'))
  database << File.read(File.join(File.dirname(__FILE__), 'data_v1.sql'))

  # convert latex subscriptions
  people = database[:people]
  database[:LATEX_SUBSCRIPTIONS].each do |t|
    people.insert(:mail       => t[:mail], 
                  :first_name => t[:first_name],
                  :last_name  => t[:last_name],
                  :occupation => t[:occupation],
                  :newsletter => false)
  end
  
  # convert news subscriptions
  database[:NEWS_SUBSCRIPTIONS].each do |t|
    if people.filter(:mail => t[:mail]).empty?
      people.insert(:mail => t[:mail], :newsletter => true)
    else
      people.filter(:mail => t[:mail]).update(:newsletter => true)
    end
  end
  
  # remove subscriptions now
  database << 'DROP TABLE "NEWS_SUBSCRIPTIONS" CASCADE;'

  # Fills the activities table
  activities = [
    {
      :id => 'conferences', :name => 'Soirées-conférences à thème', :abstract => <<-EOF
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
    },
    {
      :id => 'scienceinfuse', :name => "Science Infuse", :abstract => <<-EOF
      	<p>Découvrez les <a href="/scienceinfuse">pages consacrées</a> à
      	l'événement.</p>
      EOF
    }, 
    {
      :id => 'tutorials', :name => 'Tutoriels', :abstract => <<-EOF
      	<p>L'ASBL UCLouvain ACM Student Chapter a pour but de promouvoir
      	l'informatique au niveau scientifique et pédagogique aussi bien auprès des
      	étudiants que des professionnels. Dans ce cadre, elle organise un cycle de
      	conférences régulières. Ces dernières, d'une à deux heures chacune, offrent
      	l'opportunité de se familiariser ou de se perfectionner avec les nombreuses
      	méthodes et techniques liées à l'informatique ou ses langages de
      	programmation en vogue ou en devenir.</p>

      	<p>Etudiants et professeurs sont invités à proposer une présentation
      	tutorielle (titre et court résumé). Ces propositions sont validées par les
      	organisateurs et soumises ensuite aux préférences des auditeurs.  À la fin
      	de chaque conférence, les organisateurs présentent rapidement la liste des
      	propositions en cours et sélectionnent, pour le mois suivant, celle qui a
      	obtenu le plus de voix de préférences. Le présentateur dispose alors de
      	quatre semaines pour affiner ses slides, en collaboration avec les
      	organisateurs, afin de mettre l'accent tant sur l'attrait de la
      	présentation que sur son accessibilité à tous. Le choix de la langue
      	(anglais ou français) est laissé à l'appréciation du présentateur.</p>
      EOF
    },
    {
      :id => 'olympiades', :name => "Olympiades d'informatique", :card_path => '/olympiades', :abstract => <<-EOF
      	<p>L'IOI (International Olympiads in Informatics) organise des olympiades
      	internationales d'informatique à destination d'élèves de dernière année 
      	du secondaire. Afin de pouvoir envoyer des équipes nationales à ces
      	olympiades, chaque pays est tenu d'organiser des olympiades nationales
      	équitables au terme desquelles des candidats sont envoyés à l'épreuve
      	internationale. L'UCLouvain ACM Student Chapter fera partie de l'équipe qui
      	organisera ces olympiades pour la communauté française de Belgique. De
      	plus, elle pourrait également proposer des stages d'entraînement aux rhétos
      	sélectionnés pour les olympiades internationales.</p>
      EOF
    },
    {
      :id => 'contest', :name => "Concours d'informatique", :abstract => <<-EOF
      	<p>Il s'agit ici d'organiser des concours de programmation, avant tout pour
      	les étudiants et chercheurs de l'UCL. Le principe est simple: des problèmes
      	à résoudre sont proposés, une heure de début et de fin du concours est
      	également fixée. Les participants sont libres de résoudre le problème dans
      	n'importe quel langage, et doivent ensuite soumettre leur programme via une
      	interface web. L'exécution de ces programmes sur les exemples donnés et
      	éventuellement d'autres exemples permet de les évaluer et de désigner les
      	gagnants.</p>
      EOF
    }
  ]
  activities.each do |act|
    database[:activities].insert(act)
  end

  # Fill the events table
  events = [
    {
      :id       => 'securite_vie_privee_2010',
      :activity => 'conferences', :name => 'Conférence : Sécurité et vie privée',
      :start_time => Time.utc(2010, 03, 16, 18, 45), :end_time => Time.utc(2010, 03, 16, 22, 00),
      :location => "UCL, Louvain-la-Neuve, Auditoire SUD18",
      :card_path => '/securite-vie-privee', :status => "planned",
      :abstract => <<-EOF
        <p>La première soirée de conférences à thème de l'UCLouvain ACM Student Chapter aura lieu le 
           mardi 16 mars à Louvain-la-Neuve, dans l'auditoire SUD18. Cette soirée est composée de deux 
           conférences dont le thème principal est la sécurité et la vie privée. Les deux orateurs de 
           cette conférence sont Gildas Avoine et Luc Beirens.</p>
      EOF
    },
    {
      :id       => 'scienceinfuse_2010',
      :activity => 'scienceinfuse', :name => "Weekend Festival Scienceinfuse 2010",
      :start_time => Time.utc(2010, 03, 27, 14, 00), :end_time => Time.utc(2010, 03, 28, 17, 00), 
      :location => "UCL, Louvain-la-Neuve, Place des Sciences",
      :card_path => '/scienceinfuse', :status => "planned",
      :abstract => <<-EOF
      	<p>Dans le cadre du Printemps des Sciences 2010, se déroule le samedi 27 et
      	le dimanche 28 mars 2010 à Louvain-la-Neuve un ensemble d'activités de
      	sensibilisation à l'informatique.</p>
      EOF
    },
    {
      :id       => 'finale_olympiades_2010',
      :activity => 'olympiades', :name => "Finale des Olympiades d'informatique 2010",
      :start_time => Time.utc(2010, 05, 12, 14, 00), :end_time => Time.utc(2010, 05, 12, 19, 00), 
      :location => "UCL, Louvain-la-Neuve",
      :card_path => '/olympiades/finales', :status => "planned",
      :abstract => <<-EOF
      	<p>Les Finales des olympiades d'informatique 2010 se dérouleront à l'UCL, à Louvain-la-Neuve, 
      	le mercredi 12 mai 2010 de 14h à 19h. L'épreuve durera trois heures et la proclamation des gagnants 
      	sera faite le jour même, en fin de journée. Les deux concours comporteront deux parties : des 
      	questions sur papier et des questions à résoudre sur ordinateur. La journée se terminera par la 
      	cérémonie de remise des prix qui sera suivie d'un drink.</p>
      EOF
    }
    
  ]
  events.each do |evt|
    database[:events].insert(evt)
  end

end