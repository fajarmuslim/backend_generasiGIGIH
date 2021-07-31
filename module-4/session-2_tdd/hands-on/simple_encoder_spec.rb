require_relative 'test_helper'
require_relative 'simple_encoder'


describe SimpleEncoder do
  it 'should return empty string' do
    simple_encoder = SimpleEncoder.new
    encoded = simple_encoder.encode('')
    expect(encoded).to eq('')
  end

  it 'should encode b to k' do
    simple_encoder = SimpleEncoder.new
    encoded = simple_encoder.encode('b')
    expect(encoded).to eq('k')
  end

  it 'should encode z to i' do
    simple_encoder = SimpleEncoder.new
    encoded = simple_encoder.encode('z')
    expect(encoded).to eq('i')
  end

  it 'should encode u to p' do
    simple_encoder = SimpleEncoder.new
    encoded = simple_encoder.encode('u')
    expect(encoded).to eq('p')
  end

  it 'should encode a to v' do
    simple_encoder = SimpleEncoder.new
    encoded = simple_encoder.encode('a')
    expect(encoded).to eq('v')
  end

  it 'should encode homework to qjvzfjat' do
    simple_encoder = SimpleEncoder.new
    encoded = simple_encoder.encode('homework')
    expect(encoded).to eq('qjvzfjat')
  end
end