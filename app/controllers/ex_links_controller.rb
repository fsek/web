class ExLinksController < ApplicationController
  load_permissions_and_authorize_resource
  #before_action :set_ex_link, only: [:show, :edit, :update, :destroy]

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

end
