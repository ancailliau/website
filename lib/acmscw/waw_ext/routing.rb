module AcmScW
  class MessageFeedback < Waw::Routing::RoutingRule

    # Creates a javascript instance
    def initialize(message)
      @message = message
    end

    def generate_js_code(result, align=0)
      buffer = ""
			buffer << " "*align + "show_message('#{@message}')"
      buffer
    end
    
  end # class Javascript
end # module Waw

module Waw
  module Routing
    class DSL 
      
      def message(name)
        AcmScW::MessageFeedback.new(name)
      end
      
    end
  end
end
