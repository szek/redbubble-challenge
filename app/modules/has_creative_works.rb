module HasCreativeWorks
  def creative_works(sort_by: nil, limit: nil)
    works = self.creatives
    works = works.sort { |a, b| a.send(sort_by) <=> b.send(sort_by) } if sort_by
    works = works.first(limit) if limit
    works
  end
end