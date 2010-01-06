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
      AcmScW.transaction(AcmScW::Business::PeopleServices) do |layer|
        layer.subscribe_to_newsletter(mail)
      end
    end
    
  end # class ServicesController
end # module AcmScW