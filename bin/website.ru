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
map '/' do
  run AcmScW::Main.new
end
map '/services/subscribe' do
  use AcmScW::Services::JSON
  run AcmScW::Services::Subscribe.new
end