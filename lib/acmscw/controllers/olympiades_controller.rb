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
    
      signature {
        validation [:gender, :first_name, :last_name, :mail, :birthdate, :street, :postal_code,
                    :city, :school_name, :school_city, :category, :center], mandatory, :olympiades_mandatory_fields
        validation :mail, mail, :invalid_email
        validation :birthdate, /\d\d\/\d\d\/\d\d\d\d/.to_validator, :invalid_birthdate
      }
      routing {
        upon 'validation-ko' do form_validation_feedback end
        upon 'success/ok'    do redirect(:url => '/feedback?mkey=olympiades_registration_ok') end
      }
      # Registers to the olympiades
      def olympiades_register(params)
        :ok
      end
    
    end # class OlympiadesController
  end # module Controllers
end # module AcmScW