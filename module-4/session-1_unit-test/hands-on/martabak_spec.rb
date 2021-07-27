require_relative './martabak'

describe Martabak do
  it 'is salty' do
    martabak = Martabak.new('telor')
    taste = martabak.taste

    expect(taste).to eq('martabak telor is salty')
  end

  it 'is sweet' do
    martabak = Martabak.new('cokelat')

    taste = martabak.taste

    expect(taste).to eq('martabak cokelat is sweet')
  end

  it 'is not martabak' do
    martabak = Martabak.new('mobil')

    taste = martabak.taste

    expect(taste).to eq('martabak mobil is not martabak')
  end
end