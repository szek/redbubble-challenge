module Slugger
  def slug_for(str)
    str.gsub(/[^\w\s]/, '').gsub(/\s+/, '-').downcase
  end
end