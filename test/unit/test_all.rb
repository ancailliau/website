here = File.dirname(__FILE__)
top  = File.join(here, '..', '..')
$LOAD_PATH.unshift(File.join(top, 'lib'), File.join(top, 'vendor', 'waw', 'lib'), File.join(top, 'test', 'unit'))
require 'waw'
require 'acmscw'
require 'test/unit'

Waw.load_application(top)
raise "Tests cannot be run in production mode, to avoid modifying real database "\
      "or sending spam mails to real users." unless Waw.config.deploy_mode=='devel'

test_files = Dir[File.join(File.dirname(__FILE__), '**/*_test.rb')]
test_files.each { |file|
  require(file) 
}

