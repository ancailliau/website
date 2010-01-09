require 'rubygems'
require 'pg'
require 'sequel'
require 'rack'
require 'waw'
require 'wlang'

# Main module of the whole website
module AcmScW
  
  # Version number of ACM Student Chapter Website
  VERSION = "0.0.4".freeze
  
  # Sets the logger to use for Waw itself
  def self.logger=(logger)
    @logger = logger
  end

  # Returns the logger to use  
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  # Checks that all mandatory configuration properties are present
  def self.check_configuration
    raise "Incomplete configuration, web_domain missing" unless Waw.config.knows?(:web_domain)
    raise "Incomplete configuration, web_base missing" unless Waw.config.knows?(:web_base)
    raise "Incomplete configuration, google_analytics missing" unless Waw.config.knows?(:google_analytics)
    raise "Incomplete configuration, deploy_mode missing" unless Waw.config.knows?(:deploy_mode)
    raise "Incomplete configuration, database missing" unless Waw.config.knows?(:database)
    raise "Wrong database configuration" unless [:host, :port, :database, :user, :password, :encoding].all?{|k| Waw.config.database.has_key?(k)}
    raise "Incomplete configuration, smtp_host missing" unless Waw.config.knows?(:smtp_host)
    raise "Incomplete configuration, smtp_port missing" unless Waw.config.knows?(:smtp_port)
  end
  
  
  # Executes the given block inside a transaction
  def self.transaction()
    self.database.transaction do
      yield
    end
  end
  
  # Returns a Sequel database instance on the configuration
  def self.database
    @database ||= Sequel.postgres(Waw.config.database)
  end
      
end

require 'acmscw/validations'
require 'acmscw/business/business_services'
require 'acmscw/business/people_services'
require 'acmscw/services_controller'
require 'acmscw/tools/mail_server'