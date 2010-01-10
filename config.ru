#!/usr/bin/env rackup
here = File.dirname(__FILE__)
$LOAD_PATH.unshift(File.join(here, 'vendor', 'waw', 'lib'))
$VERBOSE = true
require 'rubygems'
require 'waw'
if app = Waw.load_application(here)
  run app
else
  puts "Unable to start webapp, see logs"
end