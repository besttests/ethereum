module Ethereum
  class Contract
    include Utils

    attr_reader :address, :json, :events, :functions, :rpc

    def initialize(json, addr = nil)
      @json = JSON.parse json
      link(addr) if addr

      @events    = @json.select {|item| item['type'] == 'event' }.map {|e| Event::ABI.new(e) }
      @functions = @json.select {|item| item['type'] == 'function' }.map {|f| Function.new(f) }
    end

    def method_missing(name, *args)
      mth = find_function(name.to_s, args)
      if mth
        data = mth.to_data(*args)
        if name.to_s =~ /!$/
          @rpc.eth_transact to: @address, data: data
        elsif name.to_s =~ /\?$/
          @rpc.eth_call to: @address, data: data
        else
          data
        end
      else
        super
      end
    end

    def find_function(name, args)
      name = name.delete '!?'
      @functions.find {|f| f.match?(name, args) }
    end

    def link(addr)
      @address = encode_address(addr)
    end

    def bind(rpc)
      @rpc = rpc
    end

    def filter(name, options={})
      event_abi = event name
      raise "event not found: #{name}" unless event_abi
      Filter.new self, event_abi, options
    end

    def event(name)
      events.find {|e| e.name == name }
    end
  end
end
