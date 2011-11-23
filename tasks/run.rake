desc "Runs the website locally"
task :run do
  FileUtils.mkdir_p "logs"
  exec("waw-start")
end
