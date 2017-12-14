require 'TagSearcher'
require 'TagHelper'

class TagsController < ApplicationController
  include TagHelper

  skip_before_action :authorize_request

  #params[:sort] -> taggings_count || name
  def index
    paginated_tags  = paginate ActsAsTaggableOn::Tag.order(sortedBy(params[:sort])),
                               per_page: params[:per_page] || 40
    render json: paginated_tags, status: :ok,
           meta: { ids: paginated_tags.map(&:id) }
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
