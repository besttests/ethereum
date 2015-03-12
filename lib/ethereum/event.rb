module Ethereum
  class Event

    class ABI
      include Utils

      attr_reader :name, :types

      def initialize(json)
        raise "Require event interface definition!" unless json['type'] == 'event'
        @interface = json
        parse
      end


      def inputs(indexed=nil)
        return @interface['inputs'] if indexed.nil?
        @interface['inputs'].select {|i| i['indexed'] == indexed }
      end

      def signature
        args = inputs.map {|i| i['type']}.join(',')
        "#{name}(#{args})"
      end

      def encoded_signature
        "0x#{sha3 signature}"
      end

      def build(data)
        Event.new(self, data)
      end

      private
      def parse
        @name = @interface['name']
        @types = @interface['inputs'].map do |arg|
          Ethereum::Type.pick arg['type']
        end
      end
    end

    attr :name, :address, :hash, :number, :args

    def initialize(abi, data)
      @abi = abi
      @raw = data
      parse
    end

    def to_s
      "#{number} #{hash} #{name} | #{address} -> #{args.inspect}"
    end

    private

    def parse
      @name    = @abi.name
      @number  = @raw['number']
      @hash    = @raw['hash'][2..-1]
      @address = @raw['address'][2..-1]
      @args    = parse_args
    end

    def parse_args
      return {} unless @raw['topic'] && @raw['topic'].size > 0

      indexed = decode_indexed
      no_indexed = decode_no_indexed
      indexed.merge(no_indexed)
    end

    def decode_indexed
      data = @raw['topic'][1..-1]
      inputs = @abi.inputs(true)

      raise "Event data didn't match definitions" if data.length != inputs.length

      padding = PADDING * 2
      result = {}
      [inputs, data].transpose.to_h.each do |input, val|
        type = Type.pick input['type']

        result[input['name']] =
          if array_type?(input['type'])
            arr_length = Type.pick('uint').decode(val[0, padding])

            1.step(to: arr_length).map do |offset|
              type.decode val[padding*offset, padding*(offset+1)]
            end
          else
            type.decode(val)
          end
      end
      result
    end

    def decode_no_indexed
      data = @raw['data'][2..-1]
      inputs = @abi.inputs(false)

      decode inputs, data
    end

    def decode(definitions, data)
      l = dynamic_part_length definitions
      dynamic_part = data[0,l]
      data = data[l..-1]

      result = {}
      padding = PADDING * 2
      definitions.each do |d|
        type = Type.pick(d['type'])
        result[d['name']] = type.decode data[0,padding]
        data = data[padding..-1]
      end

      result
    end

    def dynamic_part_length(definitions)
      definitions.reduce(0) {|acc, d| acc + dynamic_bytes_length(d['type']) }
    end

    def dynamic_bytes_length(type)
      array_type?(type) || type == 'string' ? PADDING*2 : 0
    end

    def array_type?(type)
      !!(type =~ /\[\]$/)
    end
  end
end
