require 'erb'

class WorksHtmlGenerator
  DEFAULT_WORKS_COUNT = 10

  def initialize(makes, output_dir)
    @makes = makes
    @template = File.read File.join(File.dirname(__FILE__), 'templates/work.html.erb')
    @output_dir = output_dir
  end

  def generate_tree
    setup_dirs

    save 'index.html', render_index

    @makes.each do |make| 
      make.models.each do |model|
        save "models/#{model.slug}.html", render_model(make, model)
      end

      save "makes/#{make.slug}.html", render_make(make)
    end
  end

  def render_model make, model
    @title = model.name
    @nav = { 'Index' => '../index.html',  make.name => "../makes/#{make.slug}.html" }
    @images = model.creative_works(sort_by: :date, limit: DEFAULT_WORKS_COUNT).map(&:small)
    render
  end

  def render_make make
    @title = make.name
    @nav = { 'Index' => '../index.html' }
    @images = make.creative_works(sort_by: :date, limit: DEFAULT_WORKS_COUNT).map(&:small)

    make.models.each_with_object(@nav) { |model, hash| hash[model.name] = "../models/#{model.slug}.html"}
    render
  end

  def render_index
    @title = 'Index'
    @nav = {}
    @makes.each_with_object(@nav) { |make, hash| hash[make.name] = "makes/#{make.slug}.html" }
    @images = @makes.flat_map { |make| make.creative_works }.sort { |a, b| a.date <=> b.date }
      .map(&:small).first(DEFAULT_WORKS_COUNT)
    render
  end

  def render
    ERB.new(@template).result binding
  end

  def save(filename, content)
    File.open(File.join(@output_dir, filename), 'w') { |f| f.write content }
  end

  private
  def setup_dirs
    Dir.mkdir @output_dir unless File.exists?(@output_dir)
    makes_dir = File.join(@output_dir, 'makes')
    Dir.mkdir makes_dir unless File.exists?(makes_dir)
    models_dir = File.join(@output_dir, 'models')
    Dir.mkdir models_dir unless File.exists?(models_dir)
  end
end