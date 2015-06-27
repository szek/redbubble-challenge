require_relative '../modules/slugger'
require_relative '../modules/has_creative_works'

class CameraModel
  include Slugger
  include HasCreativeWorks

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