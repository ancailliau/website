require 'rubygems'
require 'rack'
require 'easyval'

require 'waw/ext'
require 'waw/validation'
require 'waw/environment_utils'
require 'waw/controller'
require 'waw/action_controller'
require 'waw/transaction'
module Waw
  
  VERSION = "0.0.1".freeze

  extend Waw::EnvironmentUtils
end
