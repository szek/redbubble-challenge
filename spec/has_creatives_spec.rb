require_relative '../app/modules/has_creatives'
require 'ostruct'

class Foo
  include HasCreatives

  attr_accessor :creatives
end

describe HasCreatives do
  let(:array) { [1,2, 3] }
  let(:object_array) do
    [
      OpenStruct.new(name: 'C'),
      OpenStruct.new(name: 'A'),
      OpenStruct.new(name: 'B')
    ]
  end

  it 'returns creatives when no arguments are given' do
    foo = Foo.new
    foo.creatives = array

    expect(foo.creative_works).to eq array
  end

  it 'only retrives the specified amount' do
    foo = Foo.new
    foo.creatives = array

    expect(foo.creative_works(limit: 1).count).to eq 1
  end

  it 'retrieves list sorted by attribute' do
    foo = Foo.new
    foo.creatives = object_array

    list = foo.creative_works sort_by: :name
    expect(list.first.name).to eq 'A'
    expect(list.last.name).to eq 'C'
  end
end