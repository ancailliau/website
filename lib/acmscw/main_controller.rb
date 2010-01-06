module AcmScW
  class MainController
    
    # The folder of this class
    PAGES_FOLDER = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'public', 'pages'))
    
    ##############################################################################################
    ### About requested path and normalization
    ##############################################################################################
    
    # Normalizes a requested path, removing any .html, .htm suffix
    def self.normalize_req_path(req_path)
      # 1) Strip first
      req_path = req_path.strip
      # 2) Remove first slash 
      req_path = req_path[1..-1] if req_path[0,1]=='/'
      # 3) Remove last slash
      req_path = req_path[0..-2] if req_path[req_path.length-1,1]=='/'
      # 4) Remove trailing extensions
      req_path = $1 if req_path =~ /^(.*?)(\.html?)?$/
      # 5) Puts the first slash now
      req_path = "/#{req_path}"
      # 6) Handle /index
      req_path = "/" if req_path == "/index"
      # 7) Remove trailing index if any
      req_path = $1 if req_path =~ /^(.+)\/index$/
      req_path
    end
    
    # Relativize a path from the PAGES_FOLDER
    def self.relativize(file)
      file = File.expand_path(file)
      file[(PAGES_FOLDER.length+1)..-1]
    end
    
    # Find the template file corresponding to a normalized requested path. Returns nil if no
    # such file can be found
    def self.find_requested_page_file(req_path)
      # 1) Remove first slash
      req_path = req_path[1..-1]
      # 2) Map to a file
      file = File.join(PAGES_FOLDER, *req_path.split("/"))
      # 3) Seems a folder?
      if File.exists?(file) and File.directory?(file)
        file = File.join(file, 'index.wtpl')
      else
        file = "#{file}.wtpl"
      end
      File.exists?(file) and File.file?(file) ? relativize(file) : nil
    end
    
    ##############################################################################################
    ### About titles
    ##############################################################################################
    
    # Lazy load of all titles
    def titles
      @titles ||= load_titles
    end
    
    # Loads the titles from the title descriptor file
    def load_titles
      titles = {}
      File.open(File.join(PAGES_FOLDER, 'titles.txt')).readlines.each do |line|
        line = line.strip
        next if line.empty?
        raise "Title file corrupted on line |#{line}|" unless /^([\/a-zA-Z0-9_-]+)\s+(.*)$/ =~ line
        titles[$1] = $2
      end
      puts "Titles loaded #{titles.inspect}"
      titles
    end
    
    # Returns the title of a normalized requested path
    def title_of(req_path)
      title = titles[req_path]
      unless title
        puts "Warning, no dedicated title for #{req_path}"
        title = titles['/']
      end
      title
    end
    
    ##############################################################################################
    ### Main controller implementation, serving the instantiated layout
    ##############################################################################################
    
    def call(env)
      req = Rack::Request.new(env)
      
      # find the main page to compose
      req_path = MainController.normalize_req_path(req.fullpath)
      req_path, is404, page = req_path, false, MainController.find_requested_page_file(req_path)
      
      # handle 404
      req_path, is404, page = '/', true,  MainController.find_requested_page_file('/') unless page
      
      # compose it
      context = {"base_href"   => AcmScW.base_href,
                 "title"       => title_of(req_path),
                 "pagerequest" => page}
      layout = File.join(PAGES_FOLDER, 'layout.wtpl')
      composed = WLang.file_instantiate(layout, context).to_s
      
      # send result
      [is404 ? 404 : 200, {'Content-Type' => 'text/html'}, [composed]]
    end
    
  end
end
