module SimpleHL7
  class Composite
    def initialize(value = nil)
      @subcomposites = {}
      @subcomposites[1] = subcomposite_class.new(value) unless value.nil?
    end

    def []=(index, value)
      @subcomposites[index] = subcomposite_class.new(value)
    end

    def [](index)
      subcomposite = @subcomposites[index]
      if subcomposite.nil?
        subcomposite = subcomposite_class.new
        @subcomposites[index] = subcomposite
      end
      subcomposite
    end

    def current_separator_char(separator_chars)
      raise Exception.new("Subclass Responsibility")
    end

    def subcomposite_class
      raise Exception.new("Subclass Responsibility")
    end

    def each
      (1..max_index).each { |i| yield @subcomposites[i] } if max_index
    end

    def map
      (1..max_index).map { |i| yield @subcomposites[i] } if max_index
    end

    def to_hl7(separator_chars)
      sep_char = current_separator_char(separator_chars)
      map { |subc| subc.to_hl7(separator_chars) if subc }.join(sep_char)
    end

    def to_s
      @subcomposites[1].to_s
    end

    def to_a
      a = []
      each {|subc| a << subc}
      a
    end

    def method_missing(meth, *args, &block)
      if meth.to_s =~ /^e[0-9]+$/
      end
    end

    private

    def max_index
      @subcomposites.keys.max
    end

  end
end