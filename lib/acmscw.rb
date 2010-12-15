begin
  require 'waw'
rescue LoadError => ex
  require 'rubygems'
  gem 'waw',   '>= 0.3.0'
  require 'waw'
end

begin
  require 'wlang'
rescue LoadError => ex
  require 'rubygems'
  gem 'wlang', '< 1.0.0'
  require 'wlang'
end

require 'rubygems'
require 'sequel'

# Main module of the whole website
module AcmScW
  
  WLang::FILE_EXTENSIONS['.wbrick'] = 'wlang/xhtml'
  WLang::FILE_EXTENSIONS['.wrss'] = 'wlang/xhtml'
  WLang::FILE_EXTENSIONS['.form'] = 'wlang/xhtml'
  
  # Version number of ACM Student Chapter Website
  VERSION = "0.0.4".freeze
  
  # Checks that all mandatory configuration properties are present
  def self.check_configuration
    raise "Incomplete configuration, web_domain missing" unless Waw.config.knows?(:web_domain)
    raise "Incomplete configuration, web_base missing" unless Waw.config.knows?(:web_base)
    raise "Incomplete configuration, google_analytics missing" unless Waw.config.knows?(:google_analytics)
    raise "Incomplete configuration, deploy_mode missing" unless Waw.config.knows?(:deploy_mode)
    raise "Incomplete configuration, database missing" unless Waw.config.knows?(:database)
    raise "Incomplete configuration, dba_dbname missing" unless Waw.config.knows?(:dba_dbname)
    raise "Wrong database configuration" unless [:host, :port, :database, :user, :password, :encoding].all?{|k| Waw.config.database.has_key?(k)}
    raise "Incomplete configuration, smtp_config missing" unless Waw.config.knows?(:smtp_config)
  end

  ######################################################################## Views
  
  def stylesheets(folder)
    Dir[File.join(folder, "css", "*.css")].sort.collect{|file| file[folder.length..-1]}
  end
  
  def scripts(folder)
    Dir[File.join(folder, "js", "*.js")].sort.collect{|file| file[folder.length..-1]}
  end
  
  ######################################################################## Database
  
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
  
  # Returns DbAgile's environment
  def self.dba_environment
    return @dba_env if @dba_env
    @dba_env = ::DbAgile::Environment.new
    @dba_env.repository_path = File.join(File.dirname(__FILE__), '..', 'model')
    @dba_env
  end
  
  # Returns DbAgile's repository
  def self.dba_repository
    dba_environment.repository
  end
      
  # Returns DbAgile's database
  def self.dba_database
    dba_repository.database(Waw.config.dba_dbname)
  end
      
end

require 'acmscw/waw_ext/validations'
require 'acmscw/waw_ext/session'
require 'acmscw/waw_ext/routing'
require 'acmscw/waw_ext/waw_access'
require 'acmscw/business/abstract_services'
require 'acmscw/business/main_services'
require 'acmscw/business/people_services'
require 'acmscw/business/event_services'
require 'acmscw/business/activity_services'
require 'acmscw/business/olympiades_services'
require 'acmscw/business/order_services'
require 'acmscw/controllers/ensure_auth'
require 'acmscw/controllers/people_controller'
require 'acmscw/controllers/admin_controller'
require 'acmscw/controllers/event_controller'
require 'acmscw/controllers/activity_controller'
require 'acmscw/controllers/olympiades_controller'
require 'acmscw/controllers/order_controller'
