#!/usr/bin/env rackup

# Some paths
here = File.dirname(__FILE__)
lib = File.join(here, 'lib')
waw_lib = File.join(here, 'vendor', 'waw', 'lib')

# handle ruby load path and requires
$LOAD_PATH.unshift(lib, waw_lib)
require 'acmscw'
require 'logger'

# Load deployment
deploy_file = File.join(here, 'deploy')
raise "Missing deployment file 'deploy', copy and edit deploy.example first!" unless File.exists?(deploy_file)
AcmScW.load_configuration_file(deploy_file)

# Logging
logger =  Logger.new(File.join(here, 'logs', 'acmscw.log'), 'weekly')
logger.level = Logger::DEBUG
AcmScW.logger = logger
Waw.logger = logger

# handle rack services
app = Rack::Builder.new do
  use Rack::Static, :urls => ["/images", "/css", "/js", "/slides", "/downloads"], :root => 'public'  
  use Rack::CommonLogger, logger
  use Rack::ShowExceptions
  map '/' do
    run AcmScW::MainController.new
  end
  map '/services' do
    use AcmScW::JSON
    run AcmScW::ServicesController.new
  end
end
domain = $1 if (AcmScW.base_href =~ /^https?:\/\/(.*?)(:\d+)?\/$/)
logger.info("Starting acmscw application with domain #{domain}")
sessioned = Rack::Session::Pool.new(app,
  :domain       => domain,
  :expire_after => 60 * 60 * 24 # expire after 1 hour
)
run sessioned
