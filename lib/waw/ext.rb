class Hash
  def keep(*keys)
    self.delete_if{|k,v| !keys.include?(k)}
  end
end