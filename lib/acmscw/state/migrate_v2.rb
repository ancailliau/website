TOP = File.join(File.dirname(__FILE__), '..', '..', '..')
$LOAD_PATH.unshift File.join(TOP, 'lib')
require 'acmscw'

# Loads WAW configuration
Waw.load_application(TOP)

# Open a connection to the database, through sequel
database = AcmScW.database

database.transaction do |t|
  # Loads schema of version 2, then data of version 2
  database.transaction do
    database << "SET CONSTRAINTS ALL DEFERRED;"
    database << File.read(File.join(File.dirname(__FILE__), 'schema_v1.sql'))
    database << File.read(File.join(File.dirname(__FILE__), 'schema_v2.sql'))
    database << File.read(File.join(File.dirname(__FILE__), 'olympiades.sql'))
    database << File.read(File.join(File.dirname(__FILE__), 'data_v2.sql'))
  end
end
