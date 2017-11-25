class TagsController < ApplicationController
  def index
    sort_param = params[:sort] || "taggings_count"
    dir_param = params[:sort] == "taggings_count" ? "DESC" : "ASC"
    paginate ActsAsTaggableOn::Tag.order(sort_param => dir_param), per_page: 40
  end

  private

  def tag_params
    params.permit(:sort)
  end
end
