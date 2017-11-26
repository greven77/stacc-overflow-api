require 'TagSearcher'
require 'TagHelper'

class TagsController < ApplicationController
  include TagHelper

  skip_before_action :authorize_request

  #params[:sort] -> taggings_count || name
  def index
    sort_param = params[:sort] || "taggings_count"
    dir_param = params[:sort] == "taggings_count" ? "DESC" : "ASC"
    paginate json: ActsAsTaggableOn::Tag.order(sort_param => dir_param), per_page: 40
  end

  def search
    tags = TagSearcher.search(params[:search], page: params[:page],
                              per_page: params[:per_page] || 40,
                              order: sortedBy(params[:sort]))
    json_response(tags)
  end

  private

  def tag_params
    params.permit(:sort, :search)
  end
end
