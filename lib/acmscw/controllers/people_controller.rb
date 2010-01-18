module AcmScW
  module Controllers
    #
    # Defines the controller for services.
    #
    class PeopleController < ::Waw::ActionController
    
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
        upon 'validation-ko' do feedback end
        upon 'success/ok'    do refresh  end
      }
      def login(params)
        session_set(:user, params[:mail]) and :ok
      end
    
      # Lagout
      signature {}
      routing { upon '*' do refresh end }
      def logout(params)
        session_unset(:user)
        :ok
      end
    
      ### Newsletter #################################################################
    
      # Subscription to the newsletter
      signature { validation :mail, mandatory & mail, :invalid_email }
      routing { 
        upon 'validation-ko' do feedback(:hide_input => false) end 
        upon 'success/ok'    do feedback(:hide_input => true, 
                                         :message => 'newsletter_subscribe_ok') end 
      }
      def newsletter_subscribe(params)
        people_services.subscribe_to_newsletter(params[:mail]) and :ok
      end
    
      ### Account creation ###########################################################
      AccountCommonSignature = Waw::Validation.signature {
        validation :mail, mandatory & mail, :invalid_email
        validation :password, (size>=8) & (size<=15), :bad_password
        validation [:password, :password_confirm], missing | equal, :passwords_dont_match
        validation :newsletter, (default(false) | boolean), :bad_newsletter
        validation :rss_feed, missing | weburl, :bad_rss_feed
      }

      # Activation of an account
      signature(AccountCommonSignature) {
        validation :actkey, mandatory, :missing_activation_key
      }
      routing {
        upon 'error'         do feedback end
        upon 'validation-ko' do form_validation_feedback end
        upon 'success/ok'    do redirect(:url => '/people/account_activation_ok') end
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
        upon 'error', 'validation-ko' do feedback end
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
        upon 'validation-ko' do form_validation_feedback end
        upon 'success/ok'    do redirect(:url => '/feedback?mkey=subscribe_account_ok') end
      }
      def subscribe_account(params)
        args = params.keep(:mail, :password, :newsletter, :first_name, :last_name, :occupation, :rss_feed)
        people_services.subscribe(args) and :ok
      end
    
      # Account update
      signature(AccountCommonSignature) {
        validation :mail, logged, :user_must_be_logged
        validation :mail, is_current_user | user_not_exists, :mail_already_in_use
      }
      routing {
        upon 'error' do feedback end
        upon 'validation-ko' do form_validation_feedback end
        upon 'success/ok' do feedback(:hide_input => false, :message => 'update_account_ok') end
        upon 'success/activation_required' do redirect(:url => '/feedback?mkey=activation_required') end
      }
      def update_account(params)
        args = params.keep(:mail, :password, :newsletter, :first_name, :last_name, :occupation, :rss_feed)
        result = people_services.update_account(Waw.session_get(:user), args)
        case result
          when :ok
            session_set(:user, params[:mail])
          when :activation_required
            session_unset(:user)
        end
        result
      end
    
    end # class PeopleController
  end # module Controllers
end # module AcmScW