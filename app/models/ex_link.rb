class ExLink < ActiveRecord::Base
  validates :label, :url, presence: true, uniqueness: true
  has_many :ex_link_tags
  has_many :tags, through: :ex_link_tags

  attr_accessor :tagstring

  before_save :polish_tags

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
    @tagnames.join(',')
  end

  # Rewrote NICELY!
  def polish_tags
    tags = []
    tagstring.gsub!(/\s+/, '')
    tagstring.downcase.split(',').each do |tagnm|
      tags << Tag.find_or_create_by(tagname: tagnm)
    end
  end
end
