module AcmScW
  
  #
  # Controller of the application, designing a number of typical services.
  #
  class Controller
    
    # Content type of the controller
    attr_accessor :content_type
    
    # Handler for Rack calls to the controller
    def call(env)
      result = execute(Rack::Request.new(env), Rack::Response.new(env))
      [200, content_type, result]
    rescue => ex
      [500, content_type, [ex.message]]
    end
    
    # Executes the controller on a Rack::Request and Rack::Response pair
    def execute(request, response)
      raise "Should be subclassed"
    end
    
  end # class Controller

end # module AcmScW