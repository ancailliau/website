desc "Installs the basic tools (bundler and deps)"
task :install do
  puts "Installing bundler and dependencies... please wait."
  puts `gem install --no-rdoc --no-ri bundler --pre`
  puts `bundle install`
  puts `echo 'commons devel' > waw.deploy`
  puts "Done, please run 'rake db:install'"
end
