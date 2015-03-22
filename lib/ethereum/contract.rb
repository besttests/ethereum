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
      mth = function(name.to_s, *args)

      mth ? mth.call : super
    end

    def function(name, *args)
      fun_name = name.to_s.delete '!?'
      fun = @functions.find {|f| f.match?(fun_name, args) }
      if fun
        type = if name.to_s =~ /!$/
                 Function::FUNTYPE_TRANSACT
               elsif name.to_s =~ /\?$/
                 Function::FUNTYPE_CALL
               else
                 Function::FUNTYPE_DATA
               end
        fun.invoked_as(type).bind(self)
        fun
      end
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
