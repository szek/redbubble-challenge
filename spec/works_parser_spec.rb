require_relative '../app/works_parser'

describe WorksParser do
  let(:xml) { File.read File.join(File.dirname(__FILE__), 'support/works.xml') }

  it 'parses xml' do
    WorksParser.new(xml).parse
  end 

  it 'does not parse works that are not taken with a camera' do
    wp = WorksParser.new xml
    wp.parse
    expect(wp.errors.to_s).to include "Skipped Work with id:"
  end

  it 'parses and creates the appropriate objects' do
    wp = WorksParser.new xml
    wp.parse
    expect(wp.makes.count).to eq 1
    expect(wp.models.count).to eq 1
    expect(wp.works.count).to eq 1
  end
end