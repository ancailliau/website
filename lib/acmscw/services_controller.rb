module AcmScW
  #
  # Defines the controller for services.
  #
  class ServicesController < ::Waw::ActionController
    
    # Creates a ServicesController instance
    def initialize
      self.content_type = 'application/json'
    end
    
    # Encapsulate all actions through a database transaction
    def encapsulate(action, actual_params, &block)
      AcmScW.transaction(&block)
    end
    
    # Returns people_services
    def people_services
      @people_services ||= Waw.resources.business.people
    end
    
    ### Login and logout ###########################################################
    
    # Login
    signature {
      validation :mail, mandatory & mail, :bad_user_or_password
      validation :password, (size>=8) & (size<=15), :bad_user_or_password
      validation [:mail, :password], user_may_log, :bad_user_or_password
    }
    routing {
      upon 'error', 'validation_ko' do feedback end
      upon 'success/ok'             do refresh  end
    }
    def login(params)
      session_set(:user, params[:mail]) and :ok
    end
    
    # Lagout
    signature {}
    routing { upon '*' do refresh end }
    def logout(params)
      session_unset(:user)
    end
    
    ### Newsletter #################################################################
    
    # Subscription to the newsletter
    signature { validation :mail, mandatory & mail, :invalid_email }
    routing { upon '*' do feedback end }
    def newsletter_subscribe(params)
      people_services.subscribe_to_newsletter(params[:mail]) and :ok
    end
    
    ### Account creation ###########################################################
    AccountCommonSignature = Waw::Validation.signature {
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
    routing {
      upon 'error'         do feedback end
      upon 'validation_ko' do form_validation_feedback end
      upon 'success/ok'    do redirect(:url => '/people/my_chapter') end
      upon 'success/activation_required' do redirect(:url => '/feedback?mkey=activation_required') end
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
    routing {
      upon 'error', 'validation_ko' do feedback end
      upon 'success/ok'             do redirect(:url => '/feedback?mkey=activation_request_ok') end
    }
    def account_activation_request(params)
      people_services.activation_request(params[:mail]) and :ok
    end
    
    # Account creation
    signature(AccountCommonSignature) {
      validation :mail, user_not_exists, :mail_already_in_use
    }
    routing {
      upon 'error'         do feedback end
      upon 'validation_ko' do form_validation_feedback end
      upon 'success/ok'    do redirect(:url => '/feedback?mkey=subscribe_account_ok') end
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
    routing {
      upon 'error' do feedback end
      upon 'validation_ko' do form_validation_feedback end
      upon 'success/ok' do redirect(:url => '/people/my_chapter') end
      upon 'success/activation_required' do redirect(:url => '/feedback?mkey=activation_required') end
    }
    def update_account(params)
      args = params.keep(:mail, :password, :newsletter, :first_name, :last_name, :occupation, :rss_feed)
      result = people_services.update_account(Waw.session_get(:user), args)
      session_set(:user, params[:mail]) if result == :ok
      result
    end
    
  end # class ServicesController
end # module AcmScW