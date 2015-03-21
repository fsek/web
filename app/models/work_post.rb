class WorkPost < ActiveRecord::Base
  has_attached_file :picture,
                    styles: { view: '200x200>' },
                    path: ':rails_root/public/system/jobbportal/:id/:style/:filename',
                    url: '/system/jobbportal/:id/:style/:filename'
  validates_attachment_content_type :picture, content_type: /\Aimage\/.*\Z/
  validates :publish, :deadline, presence: {}
  scope :visible, -> { where(visible: true) }
  scope :publish, -> {
    visible.where(publish: DateTime.new(1937, 03, 25, 06, 07, 0)..DateTime.now.beginning_of_day).
      where(deadline: DateTime.now.beginning_of_day..DateTime.new(2137, 03, 25, 06, 07, 0))
  }
  scope :unpublish, -> { all }
end
