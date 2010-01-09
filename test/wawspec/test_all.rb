# Handle load path
here = File.dirname(__FILE__)
top  = File.join(here, '..', '..')
$LOAD_PATH.unshift(File.join(top, 'lib'), File.join(top, 'vendor', 'waw', 'lib'))

# Makes the require
require 'net/http'
require 'waw'
require 'waw/testing/wawspec'
require 'test/unit'

# Load the waw application
app = Waw.load_application(top)
raise "Tests cannot be run in production mode, to avoid modifying real database "\
      "or sending spam mails to real users." unless Waw.config.deploy_mode=='devel'

# Load waw through rack in a different thread
begin
  server = Rack::Handler::Mongrel
rescue LoadError => e
  server = Rack::Handler::WEBrick
end
t = Thread.new(app) do |app|
  options = {:Port => Waw.config.web_port, :Host => "0.0.0.0", :AccessLog => []}
  server.run app, options
end

# Wait until the server is loaded
try, ok = 0, false
begin
  Net::HTTP.get(URI.parse(Waw.config.web_base))
  ok = true
rescue Errno::ECONNREFUSED => ex
  sleep 1
end until (ok or (try += 1)>3)

test_files = Dir[File.join(File.dirname(__FILE__), '**/*.wawspec')]
test_files.each { |file|
  puts "Executing #{file}"
  load(file) 
}

