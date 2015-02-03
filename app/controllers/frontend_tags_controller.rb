class FrontendTagsController < FrontendController
  def show
    @tag = ActsAsTaggableOn::Tag.find_by(slug: params[:id])
    @pieces = Piece.tagged_with(@tag).with_published_article.page(params[:page]).per(20)
    @articles = @pieces.map(&:article).map(&:latest_published_version)

    set_cache_control_headers(24.hours)
    render 'show', layout: 'frontend'
  end
end
