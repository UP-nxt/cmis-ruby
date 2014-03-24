class String
  def underscore
    word = self.dup
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.downcase!
    word
  end
end
