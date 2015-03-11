module Ethereum
  module ABI
    class Event
      def initialize(json)
        raise "Require event interface definition!" unless json['type'] == 'event'
        @interface = json
      end
    end
  end
end
