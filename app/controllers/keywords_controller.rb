class KeywordsController < ApplicationController
  before_action :set_keyword, except: [:index, :new]

  # GET /keywords
  def index
    @keywords = Keyword.all.page params[:page]
  end

  # GET /keywords/1
  def show
    unless @keyword.published
      not_found
    end
    unless params[:k].blank?
      @kind = params[:k] if ['presses', 'comments', 'activities', 'epapers', 'books'].include? params[:k]
    else
      @kind = nil
    end
    if @kind == 'presses'
      @articles = @keyword.articles.presses.published.page params[:page]
    elsif @kind == 'comments'
      @articles = @keyword.articles.comments.published.page params[:page]
    elsif @kind == 'activities'
      @articles = @keyword.articles.activities.published.page params[:page]
    elsif @kind == 'epapers'
      @articles = @keyword.articles.epapers.published.page params[:page]
    elsif @kind == 'books'
      @articles = @keyword.articles.books.published.page params[:page]
    else
      @articles = @keyword.articles.published.page params[:page]
    end
    set_meta_tags({
      title: @keyword.title,
      description: @keyword.description,
      og: {
        image: @keyword.image.blank? ? "#{Setting.url.protocol}://#{Setting.url.host}/images/jrf-img.png" : "#{Setting.url.protocol}://#{Setting.url.host}#{@keyword.image}",
        title: @keyword.title,
        description: @keyword.description
      }
    })
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_keyword
    @keyword = params[:id] ? Keyword.find(params[:id]) : Keyword.new(keyword_params)
  end
end