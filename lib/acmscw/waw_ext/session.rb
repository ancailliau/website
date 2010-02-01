module Waw
  class Session
    
    # Current id (by mail) of the user which is logged
    session_var :user
    
    # Current tuple for the user
    query_var(:current_user) {|s| Waw.resources.model.people.filter(:mail => s[:user]).first || {}}
    
    # Administration level of the current user
    query_var(:adminlevel) {|s| s.current_user[:adminlevel] || -1}
    
  end # class Session
end # module Waw