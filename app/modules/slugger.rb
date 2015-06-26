module Slugger
  def slug_for(str)
    str.gsub(/\s+/, '-').gsub(/[^\w-]/, '').downcase
  end
end