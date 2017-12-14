module Sort
    def sortedSearch(keyword)
      case keyword
      when "relevance"
        {_score: :desc}
      when "newest"
        {created_at: :desc}
      when "votes"
        {cached_weighted_score: :desc}
      else
        {_score: :desc}
      end
    end
end
