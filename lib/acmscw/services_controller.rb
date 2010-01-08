module AcmScW
  #
  # Defines the controller for services.
  #
  class ServicesController < ::Waw::ActionController
    
    def initialize
      self.content_type = 'application/json'
    end
    
    ### Login and logout ###########################################################
    
    # Login
    signature {
      validation :mail, mandatory & mail, :bad_user_or_password
      validation :password, (size>=8) & (size<=15), :bad_user_or_password
    }
    def login(params)
      if AcmScW::Business::PeopleServices.instance.people_may_log?(params[:mail], params[:password])
        session_set(:user, params[:mail])
        :ok
      else
        :bad_user_or_password
      end
    end
    
    # Lagout
    signature {}
    def logout(params)
      session_unset(:user)
    end
    
    ### Newsletter #################################################################
    
    # Subscription to the newsletter
    signature { validation :mail, mandatory & mail, :invalid_email }
    def newsletter_subscribe(params)
      AcmScW.transaction(AcmScW::Business::PeopleServices) do |layer|
        layer.subscribe_to_newsletter(params[:mail])
      end
      :ok
    end
    
    ### Account creation ###########################################################

    # Activation of an account
    signature {
      validation :actkey, mandatory, :missing_activation_key
      validation :mail, mandatory & mail, :invalid_email
      validation :password, (size>=8) & (size<=15), :bad_password
      validation [:password, :password_confirm], mandatory & equal, :passwords_dont_match
      validation :newsletter, (default(false) | boolean), :bad_newsletter
      validation :rss_feed, missing | weburl, :bad_rss_feed
    }
    def activate_account(params)
      result = AcmScW.transaction(AcmScW::Business::PeopleServices) do |layer|
        activation_key = params[:actkey]
        update_args = params.keep(:mail, :password, :newsletter, :first_name, :last_name, :occupation, :rss_feed)
        layer.activate(activation_key, update_args)
      end
      session_set(:user, params[:mail]) if result == :ok
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
    
    # Account creation
    signature {
      validation :mail, mandatory & mail, :invalid_email
      validation :password, (size>=8) & (size<=15), :bad_password
      validation [:password, :password_confirm], mandatory & equal, :passwords_dont_match
      validation :newsletter, (default(false) | boolean), :bad_newsletter
      validation :rss_feed, missing | weburl, :bad_rss_feed
      validation :mail, AcmScW::Business::PeopleServices.user_not_exists, :mail_already_in_use
    }
    def subscribe_account(params)
      AcmScW.transaction(AcmScW::Business::PeopleServices) do |layer|
        args = params.keep(:mail, :password, :newsletter, :first_name, :last_name, :occupation, :rss_feed)
        layer.subscribe(args)
      end
      :ok
    end
    
  end # class ServicesController
end # module AcmScW