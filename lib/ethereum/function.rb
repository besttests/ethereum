module Ethereum
  class Function
    include Utils

    attr_reader :name, :types, :json

    def initialize(json)
      raise "Require function interface definition!" unless json['type'] == 'function'
      @json = json
      parse(json)
    end

    def match?(name, args)
      return false if @name != name.to_s or args.length != @types.length

      args.each_with_index do |arg, index|
        return false unless arg.is_a?(@types[index])
      end

      true
    end

    def to_data(*args)
      lengths = args.map{|arg| arg.length > -1 ? arg.length.to_s.rjust(64, '0') : nil }.compact
      args.map(&:to_bytes).unshift('0x', method_id, *lengths).join
    end

    def method_id
      arg_types = @json['inputs'].map{|input| input['type']}.join(',')
      sha3("#{name}(#{arg_types})")[0..7]
    end

    private
    def parse(json)
      @name = json['name']
      @types = json['inputs'].map do |arg|
        Ethereum::Type.pick arg['type']
      end
    end
  end
end
