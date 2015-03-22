require 'rubygems'
require 'bundler/setup'

require_relative 'lib/ethereum'

require 'pry'

rpc = Class.new.include(Ethereum::RPC).new
rpc.set_coinbase '0xb02de4ba099b1925951b72649a72c66c54cc8443'

#abi_json = File.read File.expand_path('../spec/fixtures/test.json', __FILE__)
#abi = Ethereum::Contract.new abi_json, '4ed67378d9b39b5b55197513c5b78cda076ea946'
abi_json = File.read File.expand_path('../spec/contracts/sample.json', __FILE__)
contract = Ethereum::Contract.new abi_json, 'd178759209acb485a02228181589adc1f9ab7919'
contract.bind rpc

#contract.function(:deposit!, uint(1234)).value().gas().gasValue().call
contract.withdraw!(uint(1234))#.then(->{})

f = contract.filter('Withdraw', earliest: 0)

binding.pry

#loop do
  #filter.poll
  #print '.'
  #filter.events.each do |e|
    #p e
  #end
  #sleep 2
#end
