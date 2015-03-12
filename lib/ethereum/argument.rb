module Ethereum
  class Argument
    attr_reader :type, :value

    def initialize(type, value)
      @type = type
      @value = value
      @length = value.is_a?(Array) ? value.length : -1
    end

    def === (other)
      @type === other.type and
        @value === other.value
    end

    def is_a?(atype)
      if atype.is_a?(Ethereum::Type)
        @type === atype
      else
        super
      end
    end

    def length
      @type.type == 'string' ? @value.length : @length
    end

    def eth_type
      if @value.is_a?(Array)
        @type.to_s + '[]'
      else
        @type.to_s
      end
    end

    def to_bytes
      padding = PADDING * 2
      if @length == -1
        case @type.type
        when 'uint', 'int'
          @value.to_s(16).rjust(padding, '0')
        when 'bool'
          (@value ? 1 : 0).to_s(16).rjust(padding, '0')
        when 'string'
          @value.unpack('H*').first.ljust(padding, '0')
        else
          @value
        end
      else
        @value.map{|v| @type.wrap(v).to_bytes }.join
      end
    end
  end
end
