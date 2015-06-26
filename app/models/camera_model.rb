require_relative '../modules/slugger'
require_relative '../modules/has_creatives'

class CameraModel
  include Slugger
  include HasCreatives

  attr_reader :name, :creatives, :slug

  def initialize(name)
    @name = name
    @slug = slug_for name
    @creatives = []
  end

  def add_work(work)
    @creatives << work
  end
end