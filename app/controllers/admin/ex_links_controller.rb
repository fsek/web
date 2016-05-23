# encoding:UTF-8
class Admin::ExLinksController < ApplicationController
  load_permissions_and_authorize_resource
  before_action :authorize
  before_action :set_ex_link, only: [:show, :edit, :update, :destroy]

  def index
    if params[:tag]
      @ex_links = get_exlinks_if_all_tags_present(params[:tag])
    else
      @ex_links = ExLink.all
    end
    @tags = get_tags
  end

  def show
    @ex_link = ExLink.find(params[:id])
  end

  def new
    @ex_link = ExLink.new
  end

  def edit
  end

  def create
    @ex_link = ExLink.new(ex_link_params)
    if @ex_link.save
      redirect_to admin_ex_link_path(@ex_link), notice: alert_create(ExLink)
    else
      render :new, status: 422
    end
  end

  def update
    if @ex_link.update(ex_link_params)
      redirect_to admin_ex_link_path(@ex_link), notice: alert_update(ExLink)
    else
      render :edit, status: 422
    end
  end

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
      if !possible_tag.empty?
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

  def del_unused_tags
    Tag.delete_unused_tags
    redirect_to admin_ex_links_path
  end

  def check_dead
    begin
      ExLink.aliveness_check
      msg = 'Links checked for alliveness'
    rescue StandardError => e
      msg = 'Error while cheching for alliveness of the URL: ' + e.message
    end
    redirect_to admin_ex_links_path, notice: msg
  end

  def check_expired
    begin
      ExLink.expiration_check
      msg = 'Links checked for expiration.'
    rescue StandardError => e
      msg = e.message
    end
    redirect_to admin_ex_links_path, notice: msg
  end

  private

  def set_ex_link
    @ex_link = ExLink.find(params[:id])
  end

  def ex_link_params
    params.require(:ex_link).permit(:label, :url, :test_availability, :note,
                                    :active, :expiration, :image, :tagstring)
  end

  def authorize
    authorize! :manage, ExLink
  end
end
