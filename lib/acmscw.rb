require 'rubygems'
require 'pg'
require 'sequel'
require 'rack'
require 'json'
require 'waw'
require 'wlang'

# Main module of the whole website
module AcmScW
  
  # Version number of ACM Student Chapter Website
  VERSION = "0.0.4".freeze
  
  # Configuration parameters
  CONFIG = {}
  
  # Loads the configuration from a given file
  def self.load_configuration_file(file)
    load_configuration File.read(file)
  end
  
  # Loads the configuration from a given string
  def self.load_configuration(str)
    self.instance_eval str
  end
  
  # Fired when a method is missing
  def self.method_missing(name, *args)
    CONFIG[name] = args[0]
    instance_eval <<-EOF
      def self.#{name}
        CONFIG[:#{name}] 
      end
    EOF
  end
  
  # Creates a database connection
  def self.create_db_connection
    begin
      # No connection previously created, or trying a new one
      @connection = PGconn.open(:host => AcmScW.database_host, 
                                :dbname => AcmScW.database_name, 
                                :user => AcmScW.database_user, 
                                :password => AcmScW.database_pwd)
      @connection.set_client_encoding(AcmScW.database_encoding)
      return @connection
    rescue PGError => ex
      # Fatal case, no connection can be created (is PostgreSQL running?)
      raise ex
    end
  end
  
  # Executes the given block inside a transaction
  def self.transaction(&block)
    Waw::Transaction.new(create_db_connection).go!(&block)
  end
      
end

require 'acmscw/json'
require 'acmscw/main_controller'
require 'acmscw/services_controller'