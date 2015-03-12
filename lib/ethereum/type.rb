module Ethereum
  class Type
    PrefixedTypes = %w(uint int hash string real ureal)
    NamedTypes    = %w(address bool)

    attr_reader :type, :bytes

    def initialize(name)
      md = name.match /(\D+)(\d*)/

      @type = md[1]
      @bytes = md[2].to_i

      if PrefixedTypes.include?(@type) or NamedTypes.include?(@type)
        if @bytes == 0
          case @type
          when 'uint', 'int', 'hash'
            @bytes = 256
          #when 'string'
            #@bytes = 32
          when 'real'
            @bytes = 128
          end
        end
      else
        raise 'Not A valid Ethereum Type'
      end
    end

    def to_s
      if bytes == 0
        type
      else
        [type, bytes].join
      end
    end

    def === (atype)
      if atype.is_a?(Ethereum::Type)
        @type == atype.type and
          (atype.bytes == 0 or @type.bytes == 0 or @bytes == atype.bytes)
      end
    end

    def wrap(value)
      value.is_a?(Argument) ? value : Argument.new(self, value)
    end

    def decode(bytes)
      case @type
      when 'uint', 'int'
        bytes.hex
      when 'address'
        bytes[-40..-1]
      when 'bool'
        bytes.hex == 1
      else
        bytes
      end
    end

    class << self
      attr :types
      def pick(name)
        @types ||= {}
        @types[name.to_s] ||= self.new(name)
      end
    end
  end
end
