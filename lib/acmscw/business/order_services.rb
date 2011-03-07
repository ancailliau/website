require 'digest/md5'
require 'base64'
module AcmScW
  module Business
    class OrderServices < AcmScW::Business::AbstractServices
    
      attr_reader :products, :orders
      
      # Creates a services layer instance
      def initialize
        @products = AcmScW.database[:products]
        @orders = AcmScW.database[:orders]
      end
      
      # Returns the mail agent to use
      def mail_agent
        return false
        unless @mail_agent
          @mail_agent = get_mail_agent
          template = @mail_agent.add_template(:activation)
          template.from         = "UCLouvain ACM Student Chapter <no-reply@acm-sc.be>"
          template.bcc          = ["no-reply@acm-sc.be"]
          template.subject      = "Votre inscription sur uclouvain.acm-sc.be"
          template.content_type = 'text/html'
          template.charset      = 'UTF-8'
          template.body         = File.read(File.join(File.dirname(__FILE__), 'activation_mail.wtpl'))
        end
        @mail_agent
      end
      
      # Creates a product
      def create_product(tuple)
        tuple[:id] = 1+(products.max(:id) || 0)
        AcmScW.database[:products].insert(tuple)
      end
      
      # Updates a product
      def update_product(id, tuple)
        AcmScW.database[:products].filter(:id => id).update(tuple)
      end
      
      # Deletes a product
      def remove_product(id)
        AcmScW.database[:products].filter(:id => id).delete()
      end
      
      # Creates an order
      def create_order(tuple)
        tuple[:id] = 1+(orders.max(:id) || 0)
        AcmScW.database[:orders].insert(tuple)
      end
      
    end # class OrderServices
  end # module Business
end # module AcmScW
