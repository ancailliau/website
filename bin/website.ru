#!/usr/bin/env rackup

# Some paths
here = File.dirname(__FILE__)
lib = File.join(here, '..', 'lib')
main = File.join(lib, 'acmscw', 'main')

# handle ruby load path and requires
$LOAD_PATH.unshift(lib)
require 'acmscw'

# handle rack services
use Rack::Static, :urls => ["/resources"], :root => File.join(main)
main = AcmScW::Main.new
run main
