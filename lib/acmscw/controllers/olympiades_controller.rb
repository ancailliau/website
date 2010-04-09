module AcmScW
  module Controllers
    #
    # Defines the controller for services.
    #
    class OlympiadesController < ::Waw::ActionController
      
      GENDER      = ['M', 'F']
      CATEGORY    = ['superieur', 'secondaire']
      ORIENTATION = ['civil', 'industriel', 'sciences', 'gestion', 'systèmes', 'autre']
      CENTER      = ['ucl', 'fundp', 'umons', 'ulg', 'ulb', 'hers']
      KNOWSHOW    = ['affiche', 'professeur', 'acm-sc.be', 'facebook', 'presse', 'autre']
    
      # Encapsulate all actions through a database transaction
      def encapsulate(action, actual_params, &block)
        AcmScW.transaction(&block)
      end
    
      # Returns people_services
      def olympiades_services
        @olympiades_services ||= Waw.resources.business.olympiades
      end
    
      # Registers to the olympiades
      signature {
        # Mandatory fields
        validation [:gender, :first_name, :last_name, :mail, :birthdate, 
                    :street, :postal_code, :city, :school_name, :school_city, 
                    :category, :study_level, :center], mandatory, :olympiades_mandatory_fields
                    
        # Regular expressions for mail and birthdate
        validation :mail, mail, :invalid_email
        validation :birthdate, /(0[1-9]|[12][0-9]|3[01])[\/](0[1-9]|1[012])[\/](19|20)\d\d/, :invalid_birthdate

        # combo boxes, that should never fail
        validation :gender,      is.in(*GENDER),                :should_not_fail
        validation :category,    is.in(*CATEGORY),              :should_not_fail
        validation :orientation, is.in(*ORIENTATION) | missing, :should_not_fail
        validation :center,      is.in(*CENTER),                :should_not_fail
        validation :knowshow,    is.in(*KNOWSHOW)    | missing, :should_not_fail
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
        AcmScW.database[:olympiades_registrations].insert(
          params.keep(:gender, :first_name, :last_name, :mail, :birthdate, 
                      :street, :postal_code, :city, :school_name, :school_city, 
                      :category, :study_level, :center, :orientation, :orientation_other, 
                      :knowshow, :knowshow_other)
        )
        :ok
      end
      
      # signature {
      #   validation :mail, is_admin, :forbidden
      # }
      # routing {
      #   upon 'validation-ko' do redirect(:url => 'feedback?mkey=forbidden') end 
      #   upon 'success/ok' do redirect(:url => 'feedback?mkey=send_results_announce_mail_ok') end   
      # }
      # def send_results_announce_mail(params)
      #   olympiades_services.send_results_announce_mail
      #   :ok
      # end
    
    end # class OlympiadesController
  end # module Controllers
end # module AcmScW