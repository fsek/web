class Permission < ApplicationRecord
  CUSTOM = ['all', 'cafe'].freeze
  has_many :posts, through: :permission_posts
  has_many :permission_posts
  validates :subject_class, :action, presence: true

  scope :subject, -> { order(subject_class: :asc) }

  def to_s
    %(#{subject_class} - #{action})
  end

  def subject
    case subject_class
    when nil
      nil
    when *CUSTOM
      subject_class.to_sym
    else
      subject_class.constantize
    end
  end
end
