require 'rubygems'
require 'pg'
require 'rack'
require 'json'

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
  
end

require 'acmscw/main/main'
require 'acmscw/services/json'
require 'acmscw/services/subscribe'