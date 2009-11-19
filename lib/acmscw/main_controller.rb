module AcmScW
  class MainController
    
    def call(env)
      req = Rack::Request.new(env)
      
      # find the main page to compose
      page = req.fullpath
      page = "/index.html" if page == '/'
      page = $1 if page =~ /^\/([a-zA-Z0-9_-]+)(\.html?)?\/?$/
      is404 = !File.exists?(File.join(File.dirname(__FILE__), "#{page}.wtpl"))
      page = 'index' if is404
      
      # compose it
      context = {"base_href"   => AcmScW.base_href,
                 "body_class"  => page,
                 "pagerequest" => page}
      layout = File.join(File.dirname(__FILE__), 'layout.wtpl')
      composed = WLang.file_instantiate(layout, context).to_s
      
      # send result
      [is404 ? 404 : 200, {'Content-Type' => 'text/html'}, [composed]]
    end
    
  end
end