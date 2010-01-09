require "rake/rdoctask"
require "rake/testtask"
require "rake/gempackagetask"
require "rubygems"

dir     = File.dirname(__FILE__)
lib     = File.join(dir, "lib", "acmscw.rb")
version = File.read(lib)[/^\s*VERSION\s*=\s*(['"])(\d\.\d\.\d)\1/, 2]

task :default => [:test]

desc "Lauches all tests"
Rake::TestTask.new do |test|
  test.libs       << [ "lib", "test/unit", "vendor/waw/lib" ]
  test.test_files = ['test/unit/test_all.rb']
  test.verbose    =  true
end
