module Waw
  
  # 
  # Defines a specific application controller for executing actions.
  #
  class ActionController < Waw::Controller
    
    # Provides the validation and action methods used by the Controller class.
    module ClassMethods
    
      # Defines an action parameter for the next action to be defined.
      def actionparam(*args, &block)
        @action_params = [] unless @action_params
        if block.nil?
          name, validation, ko_result = args
          block = Kernel.lambda do |value|
            result = case validation
              when Regexp
                if validation =~ value.to_s
                  [value, true]
                else
                  [nil, false]
                end
              else
                raise "Unable to use #{validation} for validation"
            end
            result
          end
          @action_params << [name, block, ko_result]
        else
          name, ko_result = args
          @action_params << [name, block, ko_result]
        end
      end
    
      # Builds some action arguments
      def build_action_args(action_params, request, response)
        args = []
        action_params.each do |name, validation, ko_result|
          value, ok = validation.call(request[name])
          if ok
            args << value
          else
            return ko_result
          end
        end
        [args, true]
      end
    
      # Fired when a method is added to the controller. This method defines a new
      # action method that performs parameter conversion and validation.
      def method_added(name)
        unless @action_params.nil? or @critical
          @critical = true
          action_params = @action_params
    
          # Create the validation method
          define_method "action_#{name}" do |request, response|
            args, ok = self.class.build_action_args(action_params, request, response)
            ok ? self.send(name, *args) : args
          end 
        end
        @action_params, @critical = nil, false
      end
    
    end # module ActionMethods
    
    # Executes the controller
    def execute(request, response)
      action_name = request.respond_to?(:script_name) ? request.script_name : request[:action]
      if action_name =~ /([a-zA-Z_]+)$/
        action = "action_#{$1}".to_sym 
        self.respond_to?(action) ? self.send(action, request, response) : :action_not_found
      else
        :action_not_found
      end
    end
  
    extend ClassMethods
  end # class ActionController

end # module Waw 