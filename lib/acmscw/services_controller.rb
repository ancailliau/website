module AcmScW
  #
  # Defines the controller for services.
  #
  class ServicesController < ::Waw::ActionController
    
    # The people business services
    attr_reader :people_services
    
    # Creates a ServicesController instance
    def initialize
      self.content_type = 'application/json'
      @people_services = AcmScW::Business::PeopleServices.instance
    end
    
    # Encapsulate all actions through a database transaction
    def encapsulate(action, actual_params, &block)
      AcmScW.transaction &block
    end
    
    ### Login and logout ###########################################################
    
    # Login
    signature {
      validation :mail, mandatory & mail, :bad_user_or_password
      validation :password, (size>=8) & (size<=15), :bad_user_or_password
      validation [:mail, :password], user_may_log, :bad_user_or_password
    }
    def login(params)
      session_set(:user, params[:mail]) and :ok
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
      people_services.subscribe_to_newsletter(params[:mail]) and :ok
    end
    
    ### Account creation ###########################################################
    AccountCommonSignature = EasyVal.signature {
      validation :mail, mandatory & mail, :invalid_email
      validation :password, (size>=8) & (size<=15), :bad_password
      validation [:password, :password_confirm], mandatory & equal, :passwords_dont_match
      validation :newsletter, (default(false) | boolean), :bad_newsletter
      validation :rss_feed, missing | weburl, :bad_rss_feed
    }

    # Activation of an account
    signature(AccountCommonSignature) {
      validation :actkey, mandatory, :missing_activation_key
    }
    def activate_account(params)
      activation_key = params[:actkey]
      update_args = params.keep(:mail, :password, :newsletter, :first_name, :last_name, :occupation, :rss_feed)
      result = people_services.activate(activation_key, update_args)
      session_set(:user, params[:mail]) if result == :ok
      result
    end
    
    # Request for activation email
    signature { 
      validation :mail, mandatory & mail, :invalid_email 
      validation :mail, user_exists, :unknown_user
    }
    def account_activation_request(params)
      people_services.activation_request(params[:mail]) and :ok
    end
    
    # Account creation
    signature(AccountCommonSignature) {
      validation :mail, user_not_exists, :mail_already_in_use
    }
    def subscribe_account(params)
      args = params.keep(:mail, :password, :newsletter, :first_name, :last_name, :occupation, :rss_feed)
      people_services.subscribe(args) and :ok
    end
    
    # Account update
    signature(AccountCommonSignature) {
      validation :mail, is_current_user | user_not_exists, :mail_already_in_use
      validation :mail, logged, :user_must_be_logged
    }
    def update_account(params)
      args = params.keep(:mail, :password, :newsletter, :first_name, :last_name, :occupation, :rss_feed)
      result = people_services.update_account(Waw.session_get(:user), args)
      session_set(:user, params[:mail]) if result == :ok
      result
    end
    
  end # class ServicesController
end # module AcmScW