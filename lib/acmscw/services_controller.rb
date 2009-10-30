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
      AcmScW.transaction do |conn|
        mail = conn.escape_string(mail)
        sql = "INSERT INTO \"NEWS_SUBSCRIPTIONS\" (\"mail\")"\
        "  SELECT '#{mail}' as \"mail\" WHERE NOT EXISTS"\
        "    (SELECT * FROM \"NEWS_SUBSCRIPTIONS\" WHERE \"mail\"='#{mail}')"
        conn.exec(sql)
      end
      :ok
    end
    
  end # class ServicesController
end # module AcmScW