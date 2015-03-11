module Ethereum
  class Contract
    attr_reader :address, :json, :events, :functions, :rpc

    def initialize(json, addr = nil)
      @json = JSON.parse json
      link(addr) if addr

      @events    = @json.select {|item| item['type'] == 'event' }.map {|e| Event.new(e) }
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
      @address = addr =~ /^0x/ ? addr : "0x#{addr}"
    end

    def bind(rpc)
      @rpc = rpc
    end
  end
end
