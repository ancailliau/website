# Handle load path
here = File.dirname(__FILE__)
top  = File.join(here, '..', '..')
$LOAD_PATH.unshift(File.join(top, 'lib'), File.join(top, 'vendor', 'waw', 'lib'))

# Makes the require
require 'net/http'
require 'waw'
require 'waw/testing/wawspec'

# Load the waw application
app = Waw.load_application(top)
raise "Tests cannot be run in production mode, to avoid modifying real database "\
      "or sending spam mails to real users." unless Waw.config.deploy_mode=='devel'

# Load waw through rack in a different thread
t = Thread.new(app) do |app|
  begin
    server = Rack::Handler::Mongrel
  rescue LoadError => e
    server = Rack::Handler::WEBrick
  end
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

t1 = Time.now
puts "Running wawspec suite (#{File.expand_path(here)})"
tt, ta, tf, te = 0, 0, 0, 0
test_files = Dir[File.join(here, '**/*.wawspec')]
test_files.each { |file|
  STDOUT.write "."
  begin
    scenario = Kernel.eval(File.read(file))
    scenario.run
    tt += 1
    ta += scenario.assertion_count
  rescue Test::Unit::AssertionFailedError => ex
    puts "\nAssertion failed: #{ex.message}"
    tf += 1
  rescue Exception => ex
    puts ex.message
    puts ex.backtrace.join("\n")
    te += 1
  end
}
puts "\nFinished in #{Time.now - t1} seconds.\n"
puts "#{tt} tests, #{ta} assertions, #{tf} failures, #{te} errors"
t.kill