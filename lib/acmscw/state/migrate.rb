require "rubygems"
gem 'wlang', '< 1.0.0'
gem 'waw',   '< 0.3.0'
require 'wlang'
require 'waw'

# Loads WAW configuration
Waw.autoload(__FILE__)

# Open a connection to the database, through sequel
database = AcmScW.database

database.transaction do |t|
  # Loads schema of version 2, then data of version 2
  database.transaction do
    database << "SET CONSTRAINTS ALL DEFERRED;"
    database << File.read(File.join(File.dirname(__FILE__), 'schema_v1.sql'))
    database << File.read(File.join(File.dirname(__FILE__), 'schema_v2.sql'))
    database << File.read(File.join(File.dirname(__FILE__), 'olympiades.sql'))
    database << File.read(File.join(File.dirname(__FILE__), 'data.sql'))
  end
end
