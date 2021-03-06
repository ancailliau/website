require 'digest/md5'
require 'base64'
module AcmScW
  module Business
    class PeopleServices < AcmScW::Business::AbstractServices
      
      # The people relation (through a Sequel Dataset instance)
      attr_reader :people
      
      # Creates a services layer instance
      def initialize
        @people = AcmScW.database[:people]
      end
      
      # Returns the mail agent to use
      def mail_agent
        unless @mail_agent
          @mail_agent = get_mail_agent
          template = @mail_agent.add_template(:activation)
          template.from         = "UCLouvain ACM Student Chapter <no-reply@acm-sc.be>"
          template.bcc          = ["no-reply@acm-sc.be"]
          template.subject      = "Votre inscription sur uclouvain.acm-sc.be"
          template.content_type = 'text/html'
          template.charset      = 'UTF-8'
          template.body         = File.read(File.join(File.dirname(__FILE__), 'activation_mail.wtpl'))
        end
        @mail_agent
      end
      
      # Generates an activation key
      def generate_activation_key
        "%0#{256 / 4}x" % rand(2**256 - 1)
      end
      alias :generate_sid :generate_activation_key
      
      ############################################################################
      ### About people finding
      ############################################################################
      
      # Filters the people dataset on a given tuple
      def this_people(id_or_mail)
        people.filter(id_or_mail?(id_or_mail) => id_or_mail)
      end
      
      # Ensures the id about an id_or_mail
      def people_id(id_or_mail)
        first = this_people(id_or_mail).first
        first ? first[:id] : nil
      end
      
      # Returns the attribute name for a given people identifier
      def id_or_mail?(id_or_mail)
        (/^\d+$/ =~ id_or_mail.to_s) ? :id : :mail
      end
      
      # Drop a given people
      def drop_people(*id_or_mail)
        id_or_mail.each do |i|
          this_people(id_or_mail).delete
        end
      end
      
      # Checks if a given user exists or not
      def people_exists?(id_or_mail)
        not(this_people(id_or_mail).empty?)
      end
      
      # Does a given user profile looks complete?
      def looks_complete?(id_or_mail)
        tuple = this_people(id_or_mail).first
        tuple && tuple[:first_name] && tuple[:last_name]
      end
      
      ############################################################################
      ### About people profiles
      ############################################################################
      
      # Creates a default profile for a given mail adress
      def create_default_profile(mail)
        people.insert(
          :id => 1+(people.max(:id) || 0), 
          :mail => mail, 
          :newsletter => false,
          :subscription_time => Time.now
        )
        activation_request(mail)
      end
      
      # Updates the profile of a user.
      def update_profile(id_or_mail, attrs)
        # First load old attributes
        old_attrs = this_people(id_or_mail).first

        # Encodes the password using MD5
        unless attrs[:password].nil? 
          attrs[:password] = Digest::MD5.hexdigest(attrs[:password])
        end
        
        # if a password is provided the user can now log
        if attrs[:password] and (old_attrs[:adminlevel] == -1)
          attrs[:adminlevel] = 0
        end

        # if the rss is changed, it must be now validated
        if attrs[:rss_feed] != old_attrs[:rss_feed]
          attrs[:rss_status] = 'requires-validation'
        end
        
        # update the profile now
        this_people(id_or_mail).update(attrs)
        
        # Mail changed, new activation required
        if attrs[:mail] and (attrs[:mail] != old_attrs[:mail])
          activation_request(attrs[:mail])
          return :activation_required
        else
          :ok
        end
      end
      alias :update_account :update_profile
      
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
        not(people.nil?) and people[:activation_key].nil? and \
                         not(people[:password].nil?) and \
                         (people[:adminlevel] >= 0) and \
                         (password.nil? or (Digest::MD5.hexdigest(password) == people[:password]))
      end
      
      # Checks if a given account is currently activated
      def account_activated?(id_or_mail)
        tuple = this_people(id_or_mail).first
        not(tuple.nil?) and tuple[:activation_key].nil?
      end
      
      # Checks if an account is currently waiting for activation
      def account_waits_activation?(id_or_mail)
        tuple = this_people(id_or_mail).first
        not(tuple.nil?) and not(tuple[:activation_key].nil?)
      end
      
      # Removes any old password and send an activation mail to some user. The later
      # must exists! Returns the activation unique key.
      def activation_request(mail, removepass=true)
        actkey = generate_activation_key
        this_people(mail).update(:activation_key => actkey)
        this_people(mail).update(:password => nil) if removepass
        
        # Send the activation mail
        context = {'web_base'    => Waw.config.web_base,
                   'activation_link' => (Waw.config.web_base + "accounts/activate/#{actkey}")}
        mail_agent.send_mail(:activation, context, mail)
        
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
        return :ko if to_update.empty?
        id = to_update.first[:id]
        
        # remove the activation key
        to_update.update(:activation_key => nil)
        
        # updates the account
        attrs.empty? ? :ok : update_profile(id, attrs)
      end
      
      # Subscribes a new user. Mail must not be already used (leads to database error)
      def subscribe(attrs)
        # Set an id and encrypt the password
        attrs = attrs.merge(
          :id                => 1+(people.max(:id) || 0),
          :password          => Digest::MD5.hexdigest(attrs[:password]),
          :subscription_time => Time.now
        )
        people.insert(attrs)
        activation_request(attrs[:mail], false)
      end
      
    end # class PeopleServices
  end # module Business
end # module AcmScW