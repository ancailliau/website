module AcmScW
  module Controllers
    #
    # Defines the controller for orders
    #
    class OrderController < ::Waw::ActionController
    
      ORDER_COLUMNS = []
    
      # Encapsulate all actions through a database transaction
      def encapsulate(action, actual_params, &block)
        AcmScW.transaction(&block)
      end
    
      # Returns people_services
      def people_services
        @people_services ||= Waw.resources.business.people
      end
    
      
      
    end # class OrderController
  end # module Controllers
end # module AcmScW
