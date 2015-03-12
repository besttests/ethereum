require_relative 'spec_helper'

describe Ethereum::Event do
  let(:contract) { Ethereum::Contract.new load_abi_json('event') }

  describe Ethereum::Event::ABI do
    let(:abi)    { contract.event 'AnonymousDeposit' }

    it "should get signature of event" do
      abi.signature.should == "AnonymousDeposit(address,uint256)"
    end

    it "should encode event signature" do
      abi.encoded_signature.should == '0xceaafb6781e240ba6b317a906047690d1c227df2d967ff3f53b44f14a62c2cab'
    end

    it "should list all inputs" do
      abi.inputs.count.should == 2
    end

    it "should list indexed inputs" do
      abi.inputs(true).first['name'].should == '_from'
    end

    it "should list no indexed inputs" do
      abi.inputs(false).first['name'].should == '_value'
    end
  end

  let(:data) do
    {"address"=>"0xc88e1a32d08002cc3b337217a49d8850c1fccea0", "data"=>"0x00000000000000000000000000000000000000000000000000006fde2b4eb000", "hash"=>"0x338f4f4b8db25a58ce70687629795c96b7c37c329d8f61578b4c4e3285c346bf", "number"=>7375, "topic"=>["0xceaafb6781e240ba6b317a906047690d1c227df2d967ff3f53b44f14a62c2cab", "0x000000000000000000000000fb13111ed07707ae0fc34c2021657dacd379f1d9"]}
  end

  let(:event) { contract.event('AnonymousDeposit').build(data) }

  it "should parse name" do
    event.name.should == 'AnonymousDeposit'
  end

  it "should parse block number" do
    event.number.should == 7375
  end

  it "should parse tx hash" do
    event.hash.should == '338f4f4b8db25a58ce70687629795c96b7c37c329d8f61578b4c4e3285c346bf'
  end

  it "should parse receiver's address" do
    event.address.should == 'c88e1a32d08002cc3b337217a49d8850c1fccea0'
  end

  it "should parse event arguments" do
    event.args['_from'].should == 'fb13111ed07707ae0fc34c2021657dacd379f1d9'
    event.args['_value'].should == 123000000000000
  end
end
