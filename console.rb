require 'rubygems'
require 'bundler/setup'

require_relative 'lib/ethereum'

require 'pry'

#abi_json = File.read File.expand_path('../spec/fixtures/test.json', __FILE__)
#abi = Ethereum::Contract.new abi_json, '4ed67378d9b39b5b55197513c5b78cda076ea946'
abi_json = File.read File.expand_path('../spec/contracts/sample.json', __FILE__)
abi = Ethereum::Contract.new abi_json, 'd178759209acb485a02228181589adc1f9ab7919'
rpc = Ethereum::RPC.new

abi.bind rpc

binding.pry
