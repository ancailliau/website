module AcmScW
  class MainController
    
    LINK_TO_PAGES = { "/"      => 'index.html',
                      "/latex" => 'latex.html'}
    
    def file_contents(file)
      File.read(File.join(File.dirname(__FILE__), file))
    end
    
    def call(env)
      req = Rack::Request.new(env)
      page = LINK_TO_PAGES[req.fullpath]
      if page
        [200, {'Content-Type' => 'text/html'}, [file_contents(page)]]
      else
        [404, {'Content-Type' => 'text/html'}, [file_contents('index.html')]]
      end
    end
    
  end
end