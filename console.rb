require 'rubygems'
require 'bundler/setup'

require_relative 'lib/ethereum'

require 'pry'

abi_json = File.read File.expand_path('../spec/fixtures/sample1.json', __FILE__)
abi = Ethereum::ABI::Contract.new abi_json, '0a040694d1387e4a276693cc109ac8183ddb6fc3'
rpc = Ethereum::RPC.new

abi.bind rpc

binding.pry
