module Slugger
  def slug_for(str)
    str.gsub(/\s+/, '-').gsub(/[^\w-]/, '')
  end
end