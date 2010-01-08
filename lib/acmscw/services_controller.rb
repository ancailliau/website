module AcmScW
  #
  # Defines the controller for services.
  #
  class ServicesController < ::Waw::ActionController
    
    def initialize
      self.content_type = 'application/json'
    end
    
    # Subscription to the newsletter
    signature { validation :mail, mandatory & mail, :invalid_email }
    def newsletter_subscribe(params)
      AcmScW.transaction(AcmScW::Business::PeopleServices) do |layer|
        layer.subscribe_to_newsletter(params[:mail])
      end
      :ok
    end
    
    # Activation of an account
    signature {
      validation :actkey, mandatory, :missing_activation_key
      validation :mail, mandatory & mail, :invalid_email
      validation [:password, :password_confirm], mandatory & equal, :passwords_dont_match
      validation :newsletter, (default(false) | boolean), :bad_newsletter
    }
    def activate_account(params)
      result = AcmScW.transaction(AcmScW::Business::PeopleServices) do |layer|
        activation_key = params[:actkey]
        update_args = params.keep(:mail, :password, :newsletter, :first_name, :last_name, :occupation, :rss_feed)
        layer.activate(activation_key, update_args)
      end
      result
    end
    
    # Request for activation email
    signature { validation :mail, mandatory & mail, :invalid_email }
    def account_activation_request(params)
      AcmScW.transaction(AcmScW::Business::PeopleServices) do |layer|
        layer.activation_request(params[:mail])
      end
      :ok
    end
    
    
  end # class ServicesController
end # module AcmScW