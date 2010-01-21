module AcmScW
  module Controllers
    #
    # Defines the controller for services.
    #
    class OlympiadesController < ::Waw::ActionController
    
      # Encapsulate all actions through a database transaction
      def encapsulate(action, actual_params, &block)
        AcmScW.transaction(&block)
      end
    
      # Registers to the olympiades
      signature {
        validation [:gender, :first_name, :last_name, :mail, :birthdate, :street, :postal_code,
                    :city, :school_name, :school_city, :category, :center], mandatory, :olympiades_mandatory_fields
        validation :mail, mail, :invalid_email
        validation :birthdate, /\d\d\/\d\d\/\d\d\d\d/, :invalid_birthdate
      }
      routing {
        upon 'validation-ko' do form_validation_feedback end
        upon 'success/ok'    do redirect(:url => '/feedback?mkey=olympiades_registration_ok') end
      }
      def register(params)
        puts params.inspect();
        :ok
      end
    
    end # class OlympiadesController
  end # module Controllers
end # module AcmScW