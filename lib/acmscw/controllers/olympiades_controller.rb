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
                    :city, :school_name, :school_city], mandatory, :olympiades_mandatory_fields
        validation :mail, mail, :invalid_email
        validation :birthdate, /\d\d\/\d\d\/\d\d\d\d/, :invalid_birthdate
        validation [:category, :study_level, :center], mandatory, :olympiades_mandatory_fields
      }
      routing {
        upon 'validation-ko' do form_validation_feedback(:scroll => :top) end
        upon 'success/ok'    do redirect(:url => '/feedback?mkey=olympiades_registration_ok') end
      }
      def register(params)
        additionals = []
        if (params[:category] == 'superieur' and Waw::Validation.is_missing?(params[:orientation]))
          additionals << [:olympiades_orientation_missing]
        end
        if (params[:orientation] == 'autre' and Waw::Validation.is_missing?(params[:orientation_other]))
          additionals << [:olympiades_orientation_missing]
        end
        if (params[:knowshow] == 'autre' and Waw::Validation.is_missing?(params[:knowshow_other]))
          additionals << [:olympiades_knowshow_other_missing]
        end
        if (params[:knowshow] == 'professeur' and Waw::Validation.is_missing?(params[:knowshow_other]))
          additionals << [:olympiades_knowshow_other_missing]
        end
        raise Waw::Validation::KO, additionals unless additionals.empty?
        Waw.logger.debug("Olympiades.register(#{params.inspect})");
        :ok
      end
    
    end # class OlympiadesController
  end # module Controllers
end # module AcmScW