#!/usr/bin/env rackup

# Some paths
here = File.dirname(__FILE__)
lib = File.join(here, 'lib')
main = File.join(lib, 'acmscw', 'main')

# handle ruby load path and requires
$LOAD_PATH.unshift(lib)
require 'acmscw'

# Load deployment
deploy_file = File.join(here, 'deploy')
raise "Missing deployment file 'deploy', copy and edit deploy.example first!" unless File.exists?(deploy_file)
AcmScW.load_configuration_file(deploy_file)

# handle rack services
use Rack::Static, :urls => ["/images", "/css"], :root => 'public'
map '/' do
  run AcmScW::MainController.new
end
map '/services' do
  use AcmScW::JSON
  run AcmScW::ServicesController.new
end