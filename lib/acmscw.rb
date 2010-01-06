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
  
  # Checks if the configuration has been loaded
  def self.loaded?
    CONFIG.size != 0
  end
  
  # Unloads the configuration
  def self.unload
    CONFIG.clear
  end
  
  # Returns the place where the deploy file should be placed
  def self.look_for_deploy_file
    File.join(File.dirname(__FILE__), '..', 'deploy')
  end
  
  # Loads the configuration from a given file
  def self.load_configuration_file(file=look_for_deploy_file)
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
      def self.#{name}(value=nil)
        (CONFIG[:#{name}] = value) if value
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
  
  # Returns a Sequel database instance on the configuration
  def self.database
    Sequel.postgres(:host     => AcmScW.database_host,
                    :user     => AcmScW.database_user,
                    :password => AcmScW.database_pwd,
                    :database => AcmScW.database_name,
                    :encoding => AcmScW.database_encoding)
  end
      
end

require 'acmscw/json'
require 'acmscw/main_controller'
require 'acmscw/services_controller'
require 'acmscw/business/business_services'
require 'acmscw/business/people_services'