module TagHelper
  def sortedBy(keyword)
    case keyword
    when "popular"
      {taggings_count: :desc}
    when "name"
      {name: :asc}
    else
      {taggings_count: :desc}
    end
  end
end
