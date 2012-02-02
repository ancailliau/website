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
        upon 'validation-ko' do feedback               end
        upon 'success/ok'    do redirect(:url => '/')  end
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
        validation :first_name, mandatory, :invalid_first_name
        validation :last_name, mandatory, :invalid_last_name
        validation :set_password, boolean | default(false), :should_not_fail
        validation [:set_password, :password, :password_confirm], valid_set_password, :bad_passwords
        validation :newsletter, (boolean | default(false)), :bad_newsletter
        validation :rss_feed, missing | weburl, :bad_rss_feed
      }

      # Account creation
      signature(AccountCommonSignature) {
        validation :mail, user_not_exists, :mail_already_in_use
        validation :set_password, boolean && (is == true), :bad_passwords
      }
      routing {
        upon 'validation-ko' do form_validation_feedback           end
        upon 'success/ok'    do redirect(:url => '/')              end
      }
      def subscribe_account(params)
        args = params.keep(:mail, :password, :newsletter, :first_name, :last_name, :occupation, :rss_feed)
        people_services.subscribe(args) and :ok
      end
    
      # Activation of an account
      signature(AccountCommonSignature) {
        validation :actkey, mandatory, :missing_activation_key
      }
      routing {
        upon 'error'                       do feedback                                     end
        upon 'validation-ko'               do form_validation_feedback                     end
        upon 'success/ok'                  do message('/accounts/activation-ok')           end
        upon 'success/activation_required' do message('/accounts/activation-required')     end
      }
      def activate_account(params)
        # Take the activation key
        activation_key = params[:actkey]
        
        # Compute the update arguments
        if params[:set_password]
          update_args = params.keep(:mail, :password, :newsletter, :first_name, :last_name, :occupation, :rss_feed)
        else
          update_args = params.keep(:mail, :newsletter, :first_name, :last_name, :occupation, :rss_feed)
        end

        # Invoke the activate service, set the user as logged if ok
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
        upon 'success/ok'             do message('/accounts/activation-request-ok') end
      }
      def account_activation_request(params)
        people_services.activation_request(params[:mail]) and :ok
      end
    
      # Account update
      signature(AccountCommonSignature) {
        validation :mail, logged, :user_must_be_logged
        validation :mail, is_current_user | user_not_exists, :mail_already_in_use
      }
      routing {
        upon 'error'                       do feedback                                 end
        upon 'validation-ko'               do form_validation_feedback                 end
        upon 'success/ok'                  do message('/accounts/update-ok')           end
        upon 'success/activation_required' do message('/accounts/activation-required') end
      }
      def update_account(params)
        # Compute the update arguments
        if params[:set_password]
          update_args = params.keep(:mail, :password, :newsletter, :first_name, :last_name, :occupation, :rss_feed)
        else
          update_args = params.keep(:mail, :newsletter, :first_name, :last_name, :occupation, :rss_feed)
        end
        
        # Invoke the update service
        result = people_services.update_account(session.get(:user), update_args)
        
        # Set the user as logged or unlogged according to result
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
