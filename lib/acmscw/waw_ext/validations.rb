module Waw
  module Validation

    # Validator for user existence
    UserExists = Waw::Validation.validator {|mail| Waw.resources.business.people.people_exists?(mail)}
    def self.user_exists() UserExists end
    def self.user_not_exists() UserExists.not end

    # Validator for user login
    UserMayLog = Waw::Validation.validator do |mail, pass|
      Waw.resources.business.people.people_may_log?(mail, pass)
    end
    def self.user_may_log() UserMayLog end
      
    # Validation that a parameter matches the current user
    IsCurrentUser = Waw::Validation.validator{|mail| mail==Waw.session_has_key?(:user)}
    def self.is_current_user() IsCurrentUser end
  
    # Checks that user is (not) logged
    UserIsLogged = Waw::Validation.validator{|*args| Waw.session_has_key?(:user)}
    def self.logged() UserIsLogged end
    def self.not_logged() UserIsLogged.not end
    
  end
end