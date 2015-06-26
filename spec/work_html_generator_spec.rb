require_relative '../app/works_html_generator'
require_relative '../app/works_parser'


describe WorksHtmlGenerator do
  let(:dir) { File.join File.dirname(__FILE__), 'temp' }
  before(:each) { Dir.mkdir dir }
  after(:each) { FileUtils.rm_rf dir }
  let(:xml) { File.read File.join(File.dirname(__FILE__), 'support/works.xml') }

  it 'generates the correct number of files' do
    wp = WorksParser.new(xml)
    wp.parse

    generator = WorksHtmlGenerator.new wp.makes, dir
    generator.generate_tree

    expect(Dir[File.join(dir, '/**/*.html')].count).to eq 3
  end
end