class Object
  def to_validator
    ::EasyVal.validator{|s| self===s}
  end
end
class Integer
  def self.to_converter
    EasyVal::converter{|s| Integer===s ? s : (/\d+/ =~ s ? s.to_i : nil)}
  end
end
