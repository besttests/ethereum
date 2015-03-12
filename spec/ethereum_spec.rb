require_relative 'spec_helper'

describe Ethereum do
  let(:contract) { Ethereum::Contract.new load_abi_json('abi') }

  it 'throws exception if did not find match function in abi json' do
    expect { contract.baz(uint8(69), bool(true)) }.to raise_error(NoMethodError)
  end

  it 'returns bytes when call function in abi json' do
    expect(contract.baz(uint32(69), bool(true))).to eq('0xcdcd77c000000000000000000000000000000000000000000000000000000000000000450000000000000000000000000000000000000000000000000000000000000001')
  end

  it 'returns bytes when call function in abi json' do
    expect(contract.sam(string('dave'), uint([1,2,3]))).to eq('0xe4ae26d6000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000036461766500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003')
  end
end
