require_relative '../modules/slugger'
require_relative '../modules/has_creative_works'

class CameraMake
  include Slugger
  include HasCreativeWorks
  
  attr_reader :name, :models, :slug

  def initialize(name)
    @name = name
    @slug = slug_for @name
    @models = []
  end

  def add_model(model)
    models << model
  end

  def creatives
    @models.flat_map { |model| model.creatives }
  end
end