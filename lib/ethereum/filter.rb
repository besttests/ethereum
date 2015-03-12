module Ethereum
  class Filter
    include Utils

    attr :id, :params, :raw, :events

    # valid options are 'earliest', 'latest', 'offset' and 'max'
    # ref: https://github.com/ethereum/wiki/wiki/JavaScript-API#web3ethfilter
    def initialize(contract, event_abi, options)
      @contract = contract
      @event_abi = event_abi

      @params = options.merge({
        address: @contract.address,
        topic: topic
      })
      @id = rpc.eth_newFilter params
    end

    def rpc
      @contract.rpc
    end

    def topic
      # TODO: encode indexed argument topics
      [@event_abi.encoded_signature]
    end

    def poll
      @raw = rpc.eth_changed(id)
      @events = @raw.map {|e| @event_abi.build(e) }
    end
  end
end
