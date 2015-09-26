class ExLinksController < ApplicationController
  before_action :set_ex_link, only: [:show, :edit, :update, :destroy]

  # GET /ex_links
  def index
    if params[:tag]
      @ex_links = query_by_tags(params[:tag])
    else
      @ex_links = ExLink.all
    end
  end

  # GET /ex_links/1
  def show
  end

  # GET /ex_links/new
  def new
    @ex_link = ExLink.new
  end

  # GET /ex_links/1/edit
  def edit
  end

  # POST /ex_links
  def create
    @ex_link = ExLink.new(ex_link_params)
    if @ex_link.save
      redirect_to @ex_link, notice: 'Ex link was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /ex_links/1
  def update
    if @ex_link.update(ex_link_params)
      redirect_to @ex_link, notice: 'Ex link was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /ex_links/1
  def destroy
    @ex_link.destroy
    redirect_to ex_links_url, notice: 'Ex link was successfully destroyed.'
  end

  # QUERY_BY_TAGS
  # TODO1: Now returns even if tag is substring of other
  # TODO1: e.g. Returns link which has tag 'bullsh' on 'bull' query
  def query_by_tags(tags_string)
    # make an input list nice
    wanted = []
    tags_string.split(',').each { |word|
      wanted << word.downcase.strip
    }
    wanted = wanted.sort
    return [] if wanted == []

    # search for every tag from input in all links
    result = []
    ExLink.all.each do |link|
      if (wanted & link.tags.split(',').uniq.sort) == wanted
        result << link
      end
    end
    return result
  end

  # LIST_TAGS /ex_links/tags
  def list_tags
    all_tags = []
    ExLink.all.each do |link|
      all_tags.concat(link.tags.split(','))
    end
    res = {}
    all_tags.uniq.each do |tag|
      res[tag] = query_by_tags(tag).length
    end
    @tags = res
    render 'list_tags'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_ex_link
    @ex_link = ExLink.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def ex_link_params
    params.require(:ex_link).permit(:label, :url, :tags, :test_availability,
                                    :note, :active, :expiration, :image)
  end

end
