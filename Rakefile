require "rake/rdoctask"
require "rake/testtask"
require 'spec/rake/spectask'
require "rake/gempackagetask"
require "rubygems"

dir     = File.dirname(__FILE__)
lib     = File.join(dir, "lib", "acmscw.rb")
version = File.read(lib)[/^\s*VERSION\s*=\s*(['"])(\d\.\d\.\d)\1/, 2]

task :default => [:test]

desc "Lauches all unit tests"
Rake::TestTask.new(:unit) do |test|
  test.libs       = [ "lib", "test/unit"]
  test.test_files = ['test/unit/test_all.rb']
  test.verbose    =  true
end

desc "Run all rspec test"
Spec::Rake::SpecTask.new(:spec) do |t|
  t.ruby_opts = ['-I.']
  t.spec_files = FileList['test/spec/test_all.rb']
end

desc "Launches wspec test"
task :wspec do
  require('test/wspec/test_all.rb')
end

task :test => [:unit, :spec, :wspec]