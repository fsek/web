class ExLink < ActiveRecord::Base
  validates :label, :url, presence: true
  before_save :polish_tags

  has_attached_file :image,
                    styles: { medium: '300x300>', thumb: '100x100>' },
                    path: ':rails_root/public/system/images/ex_link/:id/:style/:filename',
                    url: '/system/images/ex_link/:id/:style/:filename',
                    default_url: 'img/ex_link/:style/external_link_sample.png'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  protected

  # Tags could be converted to an array of string (and saving as serialized objects)
  # instead of strings. In case this would be slow...
  def polish_tags
    self.tags.gsub!(/\s+/, '')
    self.tags = self.tags.downcase
  end
end
