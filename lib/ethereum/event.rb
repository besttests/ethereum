module Ethereum
  class Event
    def initialize(json)
      raise "Require event interface definition!" unless json['type'] == 'event'
      @interface = json
    end

    def name
      @interface['name']
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
      "0x#{sha3 ascii2bytes(signature)}"
    end

    def build(data)
      Event.new(self, data)
    end
  end

end
