class ExLink < ActiveRecord::Base
  validates :label, :url, presence: true
  before_save :polish_tags

  # TODO: Adding image based on feature requests from David.
  # TODO: This is just a mock-up
  has_attached_file :image,
                    styles: { medium: "300x300>", thumb: "100x100>" },
                    path: ":rails_root/public/system/images/ex_link/:id/:style/:filename",
                    url: "/system/images/ex_link/:id/:style/:filename",
                    #default_url: "img/ex_link/:style/external_link_sample.png"
                    default_url: "img/ex_link/:style/external_link_sample.png"
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  protected

  # TODO: Tags could be converted to an array of string (and saving as serialized objects)
  # instead of strings.
  def polish_tags
    self.tags.gsub!(/\s+/, "")
    self.tags = self.tags.downcase
  end
end
