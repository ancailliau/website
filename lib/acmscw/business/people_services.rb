require 'base64'
require 'singleton'
module AcmScW
  module Business
    class PeopleServices < BusinessServices
      include Singleton
      
      # The poeple relation (through a Sequel Dataset instance)
      attr_reader :people
      
      # Creates a services layer instance
      def initialize
        @people = AcmScW.database[:people]
      end
      
      ############################################################################
      ### About people finding
      ############################################################################
      
      # Filters the people dataset on a given tuple
      def this_people(id_or_mail)
        people.filter(id_or_mail?(id_or_mail) => id_or_mail)
      end
      
      # Returns the attribute name for a given people identifier
      def id_or_mail?(id_or_mail)
        (/^\d+$/ =~ id_or_mail.to_s) ? :id : :mail
      end
      
      # Drop a given people
      def drop_people(id_or_mail)
        this_people(id_or_mail).delete
      end
      
      # Checks if a given user exists or not
      def people_exists?(id_or_mail)
        not(this_people(id_or_mail).empty?)
      end
      
      ############################################################################
      ### About people profiles
      ############################################################################
      
      # Creates a default profile for a given mail adress
      def create_default_profile(mail)
        people.insert(:mail => mail, :newsletter => false)
        activation_request(mail)
      end
      
      # Updates the profile of a user. No check is done.
      def update_profile(id_or_mail, attrs={})
        this_people(id_or_mail).update(attrs)
      end
      
      # Let someone (un)subscribe to the newsletter
      def subscribe_to_newsletter(mail, yes_or_no=true)
        create_default_profile(mail) unless people_exists?(mail)
        this_people(mail).update(:newsletter => yes_or_no)
      end
      
      # Checks if someone subscribed to the newsletter
      def subscribed_to_newsletter?(id_or_mail)
        this_people(id_or_mail).first[:newsletter]
      end
      
      ############################################################################
      ### About account login, activations and so on
      ############################################################################
      
      # Checks if someone may log into the system. If a password is provided, also
      # tests that it matches the password in the database.
      def people_may_log?(id_or_mail, password=nil)
        people = this_people(id_or_mail).first
        people and people[:activation_key].nil? and \
               not(people[:password].nil?) and \
               (people[:adminlevel] >= 0) and \
               (password.nil? or password==people[:password])
      end
      
      # Checks if a given account is currently activated
      def account_activated?(id_or_mail)
        tuple = this_people(id_or_mail).first
        tuple and tuple[:activation_key].nil?
      end
      
      # Checks if an account is currently waiting for activation
      def account_waits_activation?(id_or_mail)
        tuple = this_people(id_or_mail).first
        tuple and not(tuple[:activation_key].nil?)
      end
      
      # Creates a new pseudo-random activation key for a given account
      def activation_key(mail)
        actkey = (Kernel.rand(10000000).to_s + mail.to_s + Time.now.to_s + Kernel.rand(10000000).to_s)
        actkey = Base64.encode64(actkey).gsub(/\s/, '')
      end
      
      # Removes any old password and send an activation mail to some user. The later
      # must exists! Returns the activation unique key.
      def activation_request(mail)
        actkey = activation_key(mail)
        this_people(mail).update(:password => nil, :activation_key => actkey)
        
        # send the activation mail now
        template = File.join(File.dirname(__FILE__), 'activation_mail.wtpl')
        context = {'mail_address'    => mail,
                   'activation_link' => "#{AcmScW.base_href}/services/activate_account?actkey=#{actkey}"}
        message = WLang.file_instantiate(template, context).to_s
        AcmScW::Tools::MailServer.send_mail(message, "no-reply@acm-sc.be", mail)
        
        # return the activation key
        actkey
      end
      
      # Activates an account through an activation key.
      # Additional tuple attributes can be provided for updating the associated account.
      # Returns true if the account has been activated (the activation_key is recognized),
      # false otherwise.
      def activate(activation_key, attrs={})
        # look for account to update
        to_update = people.filter(:activation_key => activation_key)
        return false if to_update.empty?
        
        # remove the activation key and set the default adminlevel if required
        attrs = attrs.merge(:activation_key => nil)
        attrs[:adminlevel] = 0 if (attrs[:password] and not(attrs.has_key?(:adminlevel)))
        
        # updates the account
        to_update.update(attrs)
        true
      end
      
    end # class PeopleServices
  end # module Business
end # module AcmScW