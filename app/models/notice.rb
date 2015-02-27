#encoding: UTF-8
class Notice < ActiveRecord::Base
  # Relationships

  # Paperclip attachment
  # The storage folder require the use of Sendfile.
  has_attached_file :image,
                    :styles => {large: "400x400>",small: "250x250>"},
                    :path => ":rails_root/storage/notices/:id/:style-:filename"
  # Validations
  validates_presence_of :title,:description,:sort
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  # Scopes
  scope :d_published, -> {where('d_publish <= ?',Time.zone.today)}
  scope :not_removed, -> {where('d_remove > ?',Time.zone.today)}
  scope :public_n, -> {where(public: true)}

  # Assures dates are set for queries
  # /d.wessman
  before_create :check_dates
  before_update :check_dates


  # Methods

  # Return: all notices valued as published
  # /d.wessman
  def self.published
    order(sort: :asc).d_published.not_removed
  end

  # Return: all published and public notices
  # /d.wessman
  def self.public_published
    published.public_n
  end

  # Action: Change display of current notice ()
  # /d.wessman
  def display(bool)
    if bool == true
      self.d_publish = Time.zone.today - 2.days
      self.d_remove = "2094-03-25"
      self.save
    else bool == false
      self.d_remove  = Time.zone.today - 2.days
      self.save
    end
  end

  # Return: true if notice is valued to display or not
  def displayed?
    return (self.d_publish <= Time.zone.today) && (self.d_remove > Time.zone.today)
  end

  # Assures dates are set (if not present) to allow for good queries
  # Also my 100th birthday!
  # /d. wessman
  def check_dates
    if(self.d_publish.nil?) && (self.d_remove.nil?)
      self.d_remove = "2094-03-25"
      self.d_publish = Time.zone.today
    elsif(self.d_publish?)
      self.d_remove = "2094-03-25"
    elsif(self.d_remove?)
      self.d_publish = Time.zone.today
    end
  end

end