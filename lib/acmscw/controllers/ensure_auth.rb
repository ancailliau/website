module AcmScW
  module Controllers
    class EnsureAuth < ::Waw::Controller
    
      # Creates an instance with a login url to redirect to.
      def initialize(app, options)
        @app = app
        @options = options
      end
    
      # Handler for Rack calls to the controller
      def call(env)
        if Waw::Validation::is_admin.validate
          @app.call(env)
        else
          kernel.call(env.dup.merge(
            'PATH_INFO' => '/403'
          ))
        end
      end
    
    end # class EnsureAuth
  end # module Controllers
end # module AcmScW
