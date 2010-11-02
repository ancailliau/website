module AcmScW
  class PasswordValidator < Waw::Validation::Validator
    
    # Calls the block installed at initialization time    
    def validate(*values)
      convert_and_validate(*values)[0]
    end
  
    # Converts and validate
    def convert_and_validate(set, pass, confirm)
      # strip passwords
      pass, confirm = pass.to_s.strip, confirm.to_s.strip
      
      # check validity
      isempty = (pass == "") && (confirm == "")
      isvalid = ((pass == confirm) && ((pass.length >= 8) && (pass.length <= 15)))
      ok = (!(set) && isempty) || (set && isvalid)
      
      # now, convert values
      [ok, [set, pass, confirm]]
    end
      
  end # class PasswordValidator
end # module AcmScW