module Waw
  
  # 
  # Defines a specific application controller for executing actions.
  #
  class ActionController < Waw::Controller
    
    # Class methods
    class << self
      
      # Fired when a signature will be next installed
      def signature(&block)
        @signature = EasyVal.signature(&block)
      end
      
      # If a signature has been installed, let the next added method
      # become an action
      def method_added(name)
        if @signature and not(@critical)
          @critical = true                      # next method will be added by myself
          signature = @signature                # be careful about execution scope!
      
          # Introspection to find the unsecure method
          meth = instance_method(name)
      
          # Define the secure method
          define_method name do |params|
            puts "Applying #{name} with #{params.inspect}"
            ok, values = signature.apply(params)
            if ok
              # validation is ok, merge params and continue
              meth.bind(self).call(params.merge!(values))
            else
              # validation is ko
              values.first
            end
          end 
        end
        @signature, @critical = nil, false       # erase signature, leave critical section
      end
      
    end # end of class methods
    
    # Executes the controller
    def execute(env, request, response)
      action_name = request.respond_to?(:path) ? request.path : request[:action]
      puts "the action name is #{action_name}"
      if action_name =~ /([a-zA-Z_]+)$/
        action = $1.to_sym 
        puts "the action is #{action}"
        self.respond_to?(action) ? self.send(action, request.params.symbolize_keys) : :action_not_found
      else
        :action_not_found
      end
    end
  
  end # class ActionController

end # module Waw 