module TagHelper
  def sortedBy(keyword)
    case keyword
    when "taggings_count"
      {taggings_count: :desc}
    when "name"
      {name: :asc}
    else
      {taggings_count: :desc}
    end
  end
end
