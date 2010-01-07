class Regexp
  def to_validator
    EasyVal.validator {|*values| values.all?{|val| self =~ val}}
  end
end