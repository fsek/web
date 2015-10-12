# encoding: UTF-8
class News < ActiveRecord::Base
  belongs_to :author, class_name: User, foreign_key: :user_id

  has_attached_file(:image,
                    styles: { original: '4000x4000>', large: '800x800>',
                              small: '250x250>', thumb: '100x100>' },
                    path: ':rails_root/public/system/images/news/:id/:style/:filename',
                    url: '/system/images/news/:id/:style/:filename')

  # Validations
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates :title, :content, :author, presence: true

  # Scopes
  scope :all_date, -> { order(created_at: :desc) }
  scope :year, -> (date) { where('created_at >= ? AND created_at <= ?',
                                 date.beginning_of_year, date.end_of_year)}

  def to_s
    title
  end
end
