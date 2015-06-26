require_relative 'slugger'
require_relative 'has_creatives'

class CameraMake
  include Slugger
  include HasCreatives
  
  attr_reader :name, :models, :slug

  def initialize(name)
    @name = name
    @slug = slug_for @name
    @models = []
  end

  def add_model(model)
    models << model
  end

  private
  def creatives
    @models.flat_map { |model| model.creatives }
  end
end