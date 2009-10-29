require 'rubygems'
require 'pg'
require 'rack'
require 'json'
module AcmScW
  
  # Version number of ACM Student Chapter Website
  VERSION = "0.0.3".freeze
  
end
require 'acmscw/main/main'
require 'acmscw/services/json'
require 'acmscw/services/subscribe'