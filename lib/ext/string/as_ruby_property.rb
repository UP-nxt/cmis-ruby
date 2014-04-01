class String
  def as_ruby_property
    word = self.dup
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.downcase!
    word
  end
end
