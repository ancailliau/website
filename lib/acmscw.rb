require 'rubygems'
require 'pg'
require 'sequel'
require 'waw'
require 'wlang'

# Main module of the whole website
module AcmScW
  
  # Version number of ACM Student Chapter Website
  VERSION = "0.0.4".freeze
  
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
      
  ##############################################################################################
  ### About titles
  ##############################################################################################

  # Locates the titles file
  def self.titles_file
    File.join(File.dirname(__FILE__), '..', 'public', 'pages', 'titles.txt')
  end

  # Lazy load of all titles
  def self.titles
    @titles ||= load_titles
  end

  # Loads the titles from the title descriptor file
  def self.load_titles
    titles = {}
    if File.exists?(titles_file)
      File.open(titles_file).readlines.each do |line|
        line = line.strip
        next if line.empty?
        raise "Title file corrupted on line |#{line}|" unless /^([\/a-zA-Z0-9_-]+)\s+(.*)$/ =~ line
        titles[$1] = $2
      end
      Waw.logger.debug("AcmSCW titles loaded successfully")
    else
      Waw.logger.warn("AcmSCW, failed to load titles.txt, not found")
    end  
    titles
  end

  # Returns the title of a normalized requested path
  def self.title_of(req_path)
    req_path = $1 if req_path =~ /^pages(\/.*?)\.wtpl$/
    req_path = $1 if req_path =~ /^(.*?)\/index$/
    title = titles[req_path]
    unless title
      Waw.logger.warn("Warning, no dedicated title for #{req_path}")
      title = titles['/']
    end
    title
  end

end

require 'acmscw/waw_ext/validations'
require 'acmscw/waw_ext/assertions'
require 'acmscw/business/people_services'
require 'acmscw/business/event_services'
require 'acmscw/controllers/people_controller'
require 'acmscw/controllers/event_controller'
require 'acmscw/tools/mail_server'
