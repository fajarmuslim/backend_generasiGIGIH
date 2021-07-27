# frozen_string_literal: true

require_relative './wli'

describe WLI do
  it 'case empty' do
    wli = WLI.new
    like_this = wli.like_this

    expect(like_this).to eq('no one likes this')
  end

  it 'case 0' do
    wli = WLI.new
    wli.names = []
    like_this = wli.like_this

    expect(like_this).to eq('no one likes this')
  end

  it 'case 1' do
    wli = WLI.new
    wli.names = ['Peter']
    like_this = wli.like_this

    expect(like_this).to eq('Peter likes this')
  end

  it 'cases 2' do
    wli = WLI.new
    wli.names = %w[Jacob Alex]
    like_this = wli.like_this

    expect(like_this).to eq('Jacob and Alex like this')
  end

  it 'cases 3' do
    wli = WLI.new
    wli.names = %w[Max John Mark]
    like_this = wli.like_this

    expect(like_this).to eq('Max, John and Mark like this')
  end

  it 'cases > 3' do
    wli = WLI.new
    wli.names = %w[Max John Mark Max]
    like_this = wli.like_this

    expect(like_this).to eq('Max, John and 2 others like this')
  end
end
