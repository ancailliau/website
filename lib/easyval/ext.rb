class Object
  def to_validator
    ::EasyVal.validator{|*values| values.all?{|v| self===v}}
  end
  alias :to_val :to_validator
end
class Integer
  class << self
    def to_validator
      val = EasyVal.validator{|*values| values.all?{|v| Integer===v}}
      def val.convert_and_validate(*values)
        ok = values.all?{|v| Integer===v or (/\d+/ =~ v)}
        ok ? [true, values.collect{|v| v.to_s.to_i}] : [false, values]
      end
      val
    end
    alias :to_val :to_validator
  end
end
