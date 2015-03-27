#encoding: UTF-8
class Notice < ActiveRecord::Base
  # Relationships
  # Paperclip attachment
  # The storage folder require the use of Sendfile.
  has_attached_file :image,
                    styles: {large: '400x400>', small: '250x250>'},
                    path: ':rails_root/storage/notices/:id/:style-:filename'
  # Validations
  validates :title, :description, :sort, presence: true
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/

  # Scopes
  scope :d_published, -> { where('d_publish <= ?', Time.zone.today) }
  scope :not_removed, -> { where('d_remove > ?', Time.zone.today) }
  scope :public_n, -> { where(public: true) }
  scope :published, -> { order(sort: :asc).d_published.not_removed }

  # Assures dates are set for queries
  # /d.wessman
  before_create :check_dates
  before_update :check_dates

  # Methods
  # Return: all published and public notices
  # /d.wessman
  def self.public_published
    published.public_n
  end

  # Action: Change display of current notice ()
  # /d.wessman
  def display(bool)
    if bool == true
      self.update(d_publish: Time.zone.today - 2.days, d_remove: '2094-03-25')
    else
      self.update(d_remove: Time.zone.today - 2.days)
    end
  end

  # Return: true if notice is valued to display or not
  def displayed?
    d_publish <= Time.zone.today && d_remove > Time.zone.today
  end

  # Assures dates are set (if not present) to allow for good queries
  # Also my 100th birthday!
  # /d. wessman
  def check_dates
    if d_publish.nil?
      self.d_publish = Time.zone.today
    end
    if d_remove.nil?
      self.d_remove = '2094-03-25'
    end
  end
end
