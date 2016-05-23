class ExLinkTag < ActiveRecord::Base
  belongs_to :ex_link
  belongs_to :tag

  validates :ex_link, :tag, presence: true
  validates :ex_link_id, uniqueness: { scope: :tag_id }
end
