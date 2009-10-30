class Regexp
  
  def waw_action_validate(value)
    if self =~ value
      [value, true]
    else
      [value, false]
    end
  end
  
end