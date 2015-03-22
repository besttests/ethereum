module Ethereum
  class Function
    include Utils

    FUNTYPE_TRANSACT = :transact
    FUNTYPE_CALL = :call
    FUNTYPE_DATA = :data

    attr_reader :name, :types, :json, :args, :contract, :invoked_type

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

      @args = args

      true
    end

    def params(options = {})
      @options = options
      self
    end

    def invoked_as(invoked_type)
      @invoked_type = invoked_type
      self
    end

    def method_id
      arg_types = @json['inputs'].map{|input| input['type']}.join(',')
      sha3("#{name}(#{arg_types})")[0..7]
    end

    def bind(contract)
      @contract = contract
    end

    def call
      raise 'Please call me after binding to a contract' if contract.nil?

      data = to_data(*args)

      case invoked_type
      when FUNTYPE_TRANSACT
        rpc.eth_transact (@options || {}).merge(from: rpc.coinbase, to: contract.address, data: data)
      when FUNTYPE_CALL
        rpc.eth_call (@options || {}).merge(to: contract.address, data: data)
      when FUNTYPE_DATA
        data
      end
    end

    private
    def parse(json)
      @name = json['name']
      @types = json['inputs'].map do |arg|
        Ethereum::Type.pick arg['type']
      end
    end

    def rpc
      contract.rpc
    end

    def to_data(*args)
      lengths = args.map{|arg| arg.length > -1 ? arg.length.to_s.rjust(64, '0') : nil }.compact
      args.map(&:to_bytes).unshift('0x', method_id, *lengths).join
    end

  end
end
