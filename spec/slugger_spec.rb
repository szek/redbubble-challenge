require_relative '../app/modules/slugger'

class Foo
  include Slugger
end
  
describe Slugger do
  it "returns a valid slug" do
    expect(Foo.new.slug_for('valid slug')).to eq 'valid-slug'
  end

  it "downcases" do
    expect(Foo.new.slug_for('VALID SLUG')).to eq 'valid-slug'
  end

  it "strips slugs of non alphanumeric characters" do
    expect(Foo.new.slug_for('VALID $%@!(*) SLUG')).to eq 'valid-slug'
  end
end