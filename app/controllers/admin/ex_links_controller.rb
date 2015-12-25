# encoding:UTF-8
class Admin::ExLinksController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :authorize
  before_action :set_ex_link, only: [:show, :edit, :update, :destroy]

  # GET /ex_links
  def index
    if params[:tag]
      @ex_links = get_exlinks_if_all_tags_present(params[:tag])
    else
      @ex_links = ExLink.all
    end
    @tags = get_tags
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
      redirect_to admin_ex_link_path(@ex_link), notice: alert_create(ExLink)
    else
      render :new
    end
  end

  # PATCH/PUT /ex_links/1
  def update
    if @ex_link.update(ex_link_params)
      redirect_to admin_ex_link_path(@ex_link), notice: alert_update(ExLink)
    else
      render :edit
    end
  end

  # DELETE /ex_links/1
  def destroy
    @ex_link.destroy
    redirect_to admin_ex_links_path, notice: alert_destroy(ExLink)
  end

  # QUERY_BY_TAGS

  # get all ExLinks with specific tag
  def get_exlinks_if_tag_present(tagname)
    ExLink.includes(:tags).where(tags: { tagname: tagname })
  end

  # break string with tags to words and lowercase them
  # then find appropriate ID of tags with those names
  def find_tag_ids_by_names(tags_string)
    ids_of_wanted_tags = []
    tags_string.split(',').each do |word|
      possible_tag = Tag.where(tagname: word.downcase.strip)
      if possible_tag.size > 0
        ids_of_wanted_tags << possible_tag[0].id
      end
    end
    ids_of_wanted_tags
  end

  # find all exlinks which have all tags present
  def get_exlinks_if_all_tags_present(tags_string)
    ids_of_wanted_tags = find_tag_ids_by_names(tags_string)

    # TODO: Brutally inefficient. I need something like:
    # SELECT ex_link_id FROM ex_link_tags WHERE tag_id = 1
    # INTERSECT
    # SELECT ex_link_id FROM ex_link_tags WHERE tag_id = 2
    # ...
    # David thinks that 'joins' might help here
    wanted_links = []
    ExLink.all.each do |exlink|
      if (ids_of_wanted_tags - exlink.tag_ids).empty?
        wanted_links << exlink
      end
    end
    wanted_links
  end

  def get_tags
    res = {}
    Tag.all.each do |tag|
      res[tag.tagname] = tag.ex_links.size
    end
    res
  end

  # /ex_links/del_unused/tags
  def del_unused_tags
    Tag.delete_unused_tags
    redirect_to admin_ex_links_path
  end

  # /ex_links/check_dead
  def check_dead
    begin
      ExLink.aliveness_check
      msg = 'Links checked for alliveness'
    rescue Exception => e
      msg = 'Error while cheching for alliveness of the URL: ' + e.message
    end
    redirect_to admin_ex_links_path, notice: msg
  end

  # /ex_links/check_expired
  def check_expired
    begin
      ExLink.expiration_check
      msg = 'Links checked for expiration.'
    rescue Exception => e
      msg = e.message
    end
    redirect_to admin_ex_links_path, notice: msg
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_ex_link
    @ex_link = ExLink.find(params[:id])
  end

  # Never trust parameters from the scary internet, allow the white list through
  def ex_link_params
    params.require(:ex_link).permit(:label, :url, :test_availability, :note,
                                    :active, :expiration, :image, :tagstring)
  end

  def authorize
    authorize! :manage, ExLink
  end
end
