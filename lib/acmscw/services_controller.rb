module AcmScW
  #
  # Defines the controller for services.
  #
  class ServicesController < ::Waw::ActionController
    
    def initialize
      self.content_type = 'application/json'
    end
    
    # Subscription to the newsletter
    validate :mail, Waw::Validation::MANDATORY, :missing_email
    validate :mail, Waw::Validation::EMAIL, :invalid_email
    action_define :subscribe, [:mail] do |mail|
      begin
        AcmScW.transaction do |trans|
          trans.NEWS_SUBSCRIPTIONS << {:mail => mail}
        end
        :ok
      rescue PGError => ex
        puts ex.message
        puts ex.backtrace.join("\n")
        :user_already_registered
      end
    end
    
    validate :first_name, Waw::Validation::MANDATORY, :missing_first_name
    validate :last_name, Waw::Validation::MANDATORY, :missing_last_name
    validate :mail, Waw::Validation::EMAIL, :invalid_email
    validate :date, Waw::Validation::ARRAY_AT_LEAST_ONE, :missing_date
    action_define :"subscribe_latex", [:first_name, :last_name, :occupation, :mail, :formation, :date] do |fn, ln, o, m, f, d|
      begin
        AcmScW.transaction do |trans|
          trans.LATEX_SUBSCRIPTIONS << {:mail => m, :first_name => fn, :last_name => ln, :occupation => o, :formation => f}
          trans.LATEX_SUBSCRIPTION_DATES << d.collect{|date| {:mail => m, :date => date}}
        end
        :ok
      rescue PGError => ex
        :user_already_registered
      end
    end
    
  end # class ServicesController
end # module AcmScW