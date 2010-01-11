#!/usr/bin/env rackup
`vendor/waw/bin/generate_javascript > public/js/acmscw_generated.js`
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