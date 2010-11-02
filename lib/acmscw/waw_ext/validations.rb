require "acmscw/waw_ext/password_validator"
module Waw
  module Validation

   validator :user_exists,      validator {|mail| Waw.resources.business.people.people_exists?(mail)}
   validator :user_not_exists,  user_exists.not
   validator :user_may_log,     validator {|mail, pass| Waw.resources.business.people.people_may_log?(mail, pass)}

   validator :is_current_user,  validator{|mail| mail==Waw.session[:user]}
   validator :is_admin,         validator{|*args| Waw.session.adminlevel > 0}
   validator :logged,           validator{|*args| Waw.session.has_key?(:user)}
   validator :not_logged,       logged.not
   
   validator :activity_exists,  validator{|act| !AcmScW.database[:activities].filter(:id => act).empty?}   
   
   validator :event_exists,     validator{|event| Waw.resources.business.event.event_exists?(event)}  
   validator :event_not_exists, event_exists.not
   
   validator :valid_set_password, AcmScW::PasswordValidator.new
   
   validator :planned_event, validator{|event| 
     tuple = AcmScW::database[:webr_planned_events].filter(:id => event).first
     not(tuple.nil?)
  }
       
   validator :places_remaining_for_event, validator{|event| 
     Waw.resources.business.event.may_still_register?(event)
   }
  
  end
end