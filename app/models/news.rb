class News < ActiveRecord::Base  
  belongs_to :profile

  has_attached_file :image, 
                    :styles => { original: "4000x4000>", large: "800x800>", small: "250x250>",thumb: "100x100>" },                     
                    :path => ":rails_root/public/system/images/news/:id/:style/:filename",
                    :url => "/system/images/news/:id/:style/:filename"

  # Validations
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
  validate :profile_id, presence: true

  # Scopes
  scope :d_published, -> {where('d_publish <= ?',Time.zone.today)}
  scope :not_removed, -> {where('d_remove > ?',Time.zone.today)}
  scope :public_n, -> {where(public: true)}
  scope :latest, -> {order(created_at: :asc).limit(5)}
end
