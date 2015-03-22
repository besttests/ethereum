require_relative 'spec_helper'

describe Ethereum::Filter do
  let(:contract) { Ethereum::Contract.new( load_abi_json 'event') }

  before do
    contract.bind Class.new.include(Ethereum::RPC).new
    contract.link '0x123456789ABCDEF'
    contract.rpc.stub(:eth_newFilter).and_return(1)
  end

  it "should match all AnonymousDeposit events" do
    contract.filter('AnonymousDeposit').params.should == {
      address: "0x123456789ABCDEF",
      topic: ["0xceaafb6781e240ba6b317a906047690d1c227df2d967ff3f53b44f14a62c2cab"]
    }
  end

  it "should match AnonymousDeposit events since block 12345" do
    contract.filter('AnonymousDeposit', earliest: 12345).params.should == {
      earliest: 12345,
      address: "0x123456789ABCDEF",
      topic: ["0xceaafb6781e240ba6b317a906047690d1c227df2d967ff3f53b44f14a62c2cab"]
    }
  end
end
