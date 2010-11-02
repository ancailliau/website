test_files = Dir[File.join(File.dirname(__FILE__), '**/*.spec')]
test_files.each { |file|
  Kernel.load(file) 
}

