require 'net/http'
require 'uri'
require 'json'
require 'active_support/core_ext/hash/keys'

require "ethereum/version"

require_relative 'ethereum/rpc'
require_relative 'ethereum/type'
require_relative 'ethereum/argument'
require_relative 'ethereum/utils'
require_relative 'ethereum/event'
require_relative 'ethereum/function'
require_relative 'ethereum/contract'

Object.class_eval do
  include Ethereum::HandyMethods
end
