module Ethereum
  module RPC
    include Utils

    class JSONRPCError < RuntimeError; end
    class ConnectionRefusedError < StandardError; end

    attr :coinbase, :uri

    #def initialize(options = {})
      #@coinbase = options[:coinbase]
      #@uri = URI.parse(options[:uri] || 'http://10.211.55.7:8080')
    #end

    def set_uri(uri)
      @uri = URI.parse(uri)
    end

    def set_coinbase(coinbase)
      @coinbase = encode_address coinbase
    end

    def method_missing(name, *args)
      handle name, *args
    end

    def inject!(contract)
      params = { data: compile(contract) }
      eth_transact params
    end

    def handle(name, *args)
      # cpp-ethereum's id is limited to 32bit signed int, so it must be less than 2147483648
      id = (Time.now.to_f*1000).floor % 1000000000
      post_body = { 'method' => name, 'params' => args, 'jsonrpc' => '2.0', 'id' => id }.to_json
      resp = JSON.parse( http_post_request(post_body) )
      raise JSONRPCError, resp['error'] if resp['error']
      raise "id doesn't match!" unless resp['id'] == id
      result = resp['result']
      result.symbolize_keys! if result.is_a? Hash
      result
    end

    def http_post_request(post_body)
      http    = Net::HTTP.new(@uri.host, @uri.port)
      request = Net::HTTP::Post.new(@uri.request_uri)
      request.basic_auth @uri.user, @uri.password
      request.content_type = 'application/json'
      request.body = post_body
      http.request(request).body
    rescue Errno::ECONNREFUSED => e
      raise ConnectionRefusedError
    end

    def compile(contract)
      eth_solidity(contract)
    end
  end
end
