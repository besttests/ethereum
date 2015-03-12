require 'rubygems'
require 'bundler/setup'

require 'pry'

require_relative '../lib/ethereum'

RSpec.configure do |config|
  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect]
  end
end

def load_abi_json(name)
  File.read(File.expand_path "../fixtures/#{name}.json", __FILE__)
end
