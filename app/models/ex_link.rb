class ExLink < ActiveRecord::Base
  validates :label, :url, presence: true, uniqueness: true
  has_many :ex_link_tags
  has_many :tags, through: :ex_link_tags

  attr_accessor :tagstring

  before_save :add_tags

  has_attached_file :image,
                    styles: { medium: '300x300>', thumb: '100x100>' },
                    path: ':rails_root/public/system/images/ex_link/:id/:style/:filename',
                    url: '/system/images/ex_link/:id/:style/:filename',
                    default_url: 'img/ex_link/:style/external_link_sample.png'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  # for nice formating in views
  def get_tagnames
    @tagnames = []
    tags.each { |tag| @tagnames << tag.tagname }
    @tagnames
  end

  def add_tags
    self.tags = []
    polish_tags.each do |tagnm|
      tago = Tag.find_by(tagname: tagnm)
      if tago.nil?
        tago = Tag.create(tagname: tagnm)
      end
      tags << tago
    end
  end

  # Rewrote NICELY!
  def polish_tags
    tags = []
    if not tagstring.nil?
      tagstring.gsub(/\s+/m, ' ')
      tagstring.strip.downcase.split(' ').each do |tagnm|
        tags << Tag.find_or_create_by(tagname: tagnm)
      end
    end
  end

  # mark links unactive if expired
  def self.expiration_check
    current_time = Time.now.getlocal
    ExLink.find_each do |link|
      if link.expiration < current_time
        link.update_attribute(:active, false)
      end
    end
  end

  # check if current link is alive
  def self.aliveness_check
    require 'uri'
    require 'net/http'

    ExLink.where(active: true).find_each do |link|
      unless Net::HTTP.get_response(URI(link.url)) == '200'
        link.update_attribute(:active, false)
      end
    end
  end
end
