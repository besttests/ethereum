require 'rubygems'
require 'bundler/setup'

require_relative 'lib/ethereum'

require 'pry'

rpc = Class.new.include(Ethereum::RPC).new
rpc.set_uri 'http://127.0.0.1:8080'
rpc.set_coinbase '2597e14c764f8dff929388a9d178e443f9bc0d15' #'0xb02de4ba099b1925951b72649a72c66c54cc8443'

abi_json = File.read File.expand_path('../spec/contracts/sample.json', __FILE__)
contract = Ethereum::Contract.new abi_json, 'e45a407e25a010236eb586aca40aa0493883ab01' #'d178759209acb485a02228181589adc1f9ab7919'
contract.bind rpc

contract.function(:deposit!, uint(1234)).params(value: 10000000, gas: 1000, gasPrice: 1000000).call
contract.withdraw!(address('d2e552b87ae214cffe3fa53419e29f8d90d35a8f'), uint(1234))#.then(->{})

#f = contract.filter('Withdraw', earliest: 0)

#binding.pry

#loop do
  #filter.poll
  #print '.'
  #filter.events.each do |e|
    #p e
  #end
  #sleep 2
#end
