TOP = File.join(File.dirname(__FILE__), '..')
$LOAD_PATH.unshift File.join(TOP, 'lib')
require 'acmscw'

# Loads the AcmScW configuration
deploy_file = File.join(TOP, 'deploy')
raise "Missing deployment file 'deploy', copy and edit deploy.example first!" unless File.exists?(deploy_file)
AcmScW.load_configuration_file(deploy_file)

# Open a connection to the database, through sequel
database = AcmScW.database

database.transaction do |t|
  # Loads schema of version 1 then 2, then data of version 1
  database << File.read(File.join(File.dirname(__FILE__), 'schema_v1.sql'))
  database << File.read(File.join(File.dirname(__FILE__), 'schema_v2.sql'))
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
  # database << 'DROP TABLE "NEWS_SUBSCRIPTIONS" CASCADE;'
end