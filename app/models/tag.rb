class Tag < ActiveRecord::Base
  validates :tagname, presence: true, uniqueness: true

  has_many :ex_link_tags
  has_many :ex_links, through: :ex_link_tags

  # TODO: this is repetitive from ex_links_controller list_tags!
  # This should be method of Tag, not instance of Tag
  def self.delete_unused_tags
    Tag.find_each do |tag|
      if tag.ex_links.empty?
        tag.destroy
      end
    end
  end
end
