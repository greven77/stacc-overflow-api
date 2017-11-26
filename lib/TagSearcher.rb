class TagSearcher < ActsAsTaggableOn::Tag
  searchkick searchable: [:name]
end
