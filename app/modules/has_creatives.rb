module HasCreatives
  def creative_works(sort_by: nil, limit: nil)
    works = creatives
    works = works.sort { |a, b| a.send(sort_by) <=> b.send(sort_by) } if sort_by
    works.first(limit) if limit
  end
end