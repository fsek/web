class Contact < ActiveRecord::Base
  translates(:name, :text)
  globalize_accessors(locales: [:en, :sv],
                      attributes: [:name, :text])

  belongs_to :post
  has_many :users, through: :post
  has_many :events, dependent: :nullify

  validates :name, presence: true, if: 'post_id.nil?'
  validates :email, :text, presence: true
  validates :email, uniqueness: true, format: { with: Devise::email_regexp }
  validates :post_id, :slug, uniqueness: { allow_blank: true }

  mount_uploader :avatar, AvatarUploader

  attr_accessor :message
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  after_update :crop_avatar

  def crop_avatar
    avatar.recreate_versions! if crop_x.present?
  end

  scope :publik, -> { where(public: true) }
  scope :with_post, -> { includes(:post, :translations) }
  scope :for_index, -> { with_post.includes(:users).sort_by(&:to_s) }

  def send_email
    if message.validate!
      ContactMailer.contact_email(self).deliver_now
      true
    else
      false
    end
  end

  def to_s
    if post.present? && name.blank?
      post.title
    else
      name
    end
  end

  def full_string
    post_name || name
  end

  private

  def post_name
    if post.present? && post.users.count == 1
      "#{post.title} - #{post.users.first.firstname}"
    elsif post.present?
      post.title
    end
  end
end
