require 'net/smtp'
module AcmScW
  module Tools
    class MailServer
      
      # Sends an e-mail
      def self.send_mail(msg, from, to)
        if AcmScW.deploy_mode == 'devel'
          to.each {|t| File.open("/tmp/#{t}.txt", 'w') {|io| io << msg}}
        else
          smtp_conn = Net::SMTP.new('smtp.skynet.be', 25)
          smtp_conn.open_timeout = 2
          smtp_conn.start {|smtp| smtp.send_message msgstr, from, *to}
        end
      end
      
      # Cleans sent mail to a list of adresses.
      # Using this method does not make sense in production mode.
      def self.clean(*to)
        to.each {|t| File.unlink("/tmp/#{t}.txt") if File.exists?("/tmp/#{t}.txt")}
      end
      
      # Checks if a mail has been correctly sent to soe people.
      # Using this method does not make sense in production mode.
      def self.mail_has_been_sent?(*to)
        to.all? {|t| File.exists?("/tmp/#{t}.txt")}
      end
      
      # Returns the contents of the last mail sent to a given adress.
      # Using this method does not make sense in production mode.
      def self.mail_contents(to)
        File.read("/tmp/#{to}.txt")
      end
      
    end # class MailServer
  end # module Tools
end # module AcmScW