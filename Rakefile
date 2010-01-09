require "rake/rdoctask"
require "rake/testtask"
require "rake/gempackagetask"
require "rubygems"

dir     = File.dirname(__FILE__)
lib     = File.join(dir, "lib", "acmscw.rb")
version = File.read(lib)[/^\s*VERSION\s*=\s*(['"])(\d\.\d\.\d)\1/, 2]

task :default => [:test]

desc "Lauches all tests"
Rake::TestTask.new(:unit_test) do |test|
  test.libs       << [ "lib", "vendor/waw/lib", "test/unit"]
  test.test_files = ['test/unit/test_all.rb', 'vendor/waw/test/unit/test_all.rb']
  test.verbose    =  true
end

desc "Launches wawspec test"
task :test => :unit_test do
  require('test/wawspec/test_all.rb')
end