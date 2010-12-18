module AcmScW
  module Controllers
    #
    # Defines the controller for orders
    #
    class OrderController < ::Waw::ActionController
    
      ORDER_COLUMNS = []
      
      PRODUCT_COLUMNS = [:name, :price, :available_size]
    
      # Encapsulate all actions through a database transaction
      def encapsulate(action, actual_params, &block)
        AcmScW.transaction(&block)
      end
    
      # Returns people_services
      def people_services
        @people_services ||= Waw.resources.business.people
      end
      
      # Returns order_services
      def order_services
        @order_services ||= Waw.resources.business.order
      end
    
      ######################################################################### Creation of products
    
      ProductCommonSignature = Waw::Validation.signature {
        validation :name, mandatory, :invalid_product_name
        validation :price, (float & (is >= 0.0)), :invalid_product_price
        validation :available_size, mandatory, :invalid_product_available_size
      }

      signature(ProductCommonSignature) {
        validation :name, is_admin, :must_be_admin
      }
      routing {
        upon 'validation-ko' do form_validation_feedback     end
        upon 'success/ok'    do message('/admin/orders/create-product-ok')  end
      }
      def create_product(params)
        order_services.create_product(params.keep(*PRODUCT_COLUMNS))
        :ok
      end
      
      signature(ProductCommonSignature) {
        validation :name, is_admin, :must_be_admin
        validation :id, (mandatory & integer & (is >= 0)), :invalid_product_id
      }
      routing {
        upon 'validation-ko' do form_validation_feedback                   end
        upon 'success/ok'    do message('/admin/orders/update-product-ok') end
      }
      def update_product(params)
        order_services.update_product(params.keep(:id)[:id],params.keep(*PRODUCT_COLUMNS))
        :ok
      end
      
      signature {
        validation :name, is_admin, :must_be_admin
        validation :id, (mandatory & integer & (is >= 0)), :invalid_product_id
      }
      routing {
        upon 'validation-ko' do message('/admin/orders/remove-product-ko')  end
        upon 'success/ok'    do message('/admin/orders/remove-product-ok')  end
      }
      def remove_product(params)
        order_services.remove_product(params.keep(:id)[:id])
        :ok
      end
      
    end # class OrderController
  end # module Controllers
end # module AcmScW
