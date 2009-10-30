module Waw
  
  # 
  # Defines a specific application controller for executing actions.
  #
  class ActionController < Waw::Controller
    
    # Provides the validation and action methods used by the Controller class.
    module ClassMethods
    
      # Installs a validation rule for the next action to define
      def validate(*args, &block)
        @validations = [] unless @validations
        if block.nil?
          name, validation, ko_result = args
          block = Kernel.lambda do |arg_value|
            if validation.respond_to?(:waw_action_validate)
              validation.waw_action_validate(arg_value)
            elsif Proc===validation
              validation.call(arg_value)
            else
              raise "Unable to use #{validation} for action argument validation"
            end
          end
          @validations << [name, block, ko_result]
        else
          name, ko_result = args
          @validations << [name, block, ko_result]
        end
      end
    
      # Converts and validate action arguments
      def validate_action_arguments(arg_names, args, validations)
        validations.each do |name, validation, ko_result|
          index = arg_names.index(name)
          value, ok = validation.call(args[index])
          if ok
            args[index] = value
          else
            return ko_result
          end
        end
        [args, true]
      end
    
      # Adds an action definition
      def action_define(name, arg_names, &block)
        validations = @validations || []
        define_method "action_#{name}" do |request, response|
          args = arg_names.collect{|arg_name| request[arg_name]}
          self.send(name, *args)
        end
        define_method name do |*args|
          args, ok = self.class.validate_action_arguments(arg_names, args, validations)
          ok ? self.instance_exec(*args, &block) : args
        end
        @validations = nil
      end
    
    end # module ActionMethods
    
    # Executes the controller
    def execute(request, response)
      action_name = request.respond_to?(:fullpath) ? request.fullpath : request[:action]
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