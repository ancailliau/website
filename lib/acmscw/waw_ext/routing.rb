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

  class FakePost < Waw::Routing::RoutingRule
    
    def generate_js_code(result, align = 0)
      buffer = ""
      buffer << <<-EOF
        $(form).unbind("submit");
        $(form).attr("method", "POST");
        $(form).attr("action", "/fakepost").submit();
      EOF
      buffer.gsub(/^\s*/m, " "*align)
    end
  end

end # module Waw

module Waw
  module Routing
    class DSL 
      
      def message(name)
        AcmScW::MessageFeedback.new(name)
      end

      def fakepost
        AcmScW::FakePost.new
      end
      
    end
  end
end
