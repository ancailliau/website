module AcmScW
  class MainController
    
    # Finds the page file that maps a given request
    def self.find_requested_page_file(req_path)
      req_path = "#{req_path}index" if req_path[req_path.length-1, 1] == '/'
      req_path = req_path[1..-1] if req_path[0,1]=='/'
      req_path = $1 if req_path =~ /^(.*?)(\.html?)?$/
      req_path = "#{req_path}.wtpl"
      File.exists?(File.join(File.dirname(__FILE__), req_path)) ? req_path : nil
    end
    
    def call(env)
      req = Rack::Request.new(env)
      
      # find the main page to compose
      is404, page = false, MainController.find_requested_page_file(req.fullpath)
      is404, page = true,  MainController.find_requested_page_file('/') unless page
      
      # compose it
      the_class = $1 if page =~ /([a-zA-Z0-9-_]+)\.wtpl$/
      context = {"base_href"   => AcmScW.base_href,
                 "body_class"  => the_class,
                 "pagerequest" => page}
      layout = File.join(File.dirname(__FILE__), 'layout.wtpl')
      composed = WLang.file_instantiate(layout, context).to_s
      
      # send result
      [is404 ? 404 : 200, {'Content-Type' => 'text/html'}, [composed]]
    end
    
  end
end
