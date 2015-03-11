require_relative 'abi/type'
require_relative 'abi/argument'
require_relative 'abi/utils'
require_relative 'abi/event'
require_relative 'abi/function'
require_relative 'abi/contract'

Object.class_eval do
  include Ethereum::HandyMethods
end
