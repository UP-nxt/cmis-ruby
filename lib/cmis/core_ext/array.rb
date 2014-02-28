class Array
  def with_indifferent_access
    map do |value|
      case value
      when Hash
        value.with_indifferent_access
      when Array
        value.with_indifferent_access
      else
        value
      end
    end
  end
end
