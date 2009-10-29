module AcmScW
  class Main
    
    def index_contents
      File.read(File.join(File.dirname(__FILE__), "index.html"))
    end
    
    def call(env)
      [200, {'Content-Type' => 'text/html'}, [index_contents]]
    end
    
  end
end