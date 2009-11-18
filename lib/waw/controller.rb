module Waw
  
  #
  # Controller of a web application, designing a number of typical services.
  #
  class Controller
    
    # Content type of the controller
    attr_accessor :content_type
    
    # Handler for Rack calls to the controller
    def call(env)
      req, res = Rack::Request.new(env), Rack::Response.new(env)
      result = execute(req, res)
      puts "Returning 200 with #{result}"
      [200, {'Content-Type' => content_type}, result]
    rescue => ex
      puts "Fatal error #{ex.message}"
      puts ex.backtrace.join("\n")
      puts "Returning 500 with #{result}"
      [500, {'Content-Type' => content_type}, [ex.message]]
    end
    
    # Executes the controller on a Rack::Request and Rack::Response pair
    def execute(request, response)
      raise "Should be subclassed"
    end
    
  end # class Controller

end # module Waw