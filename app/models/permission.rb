class Permission < ActiveRecord::Base
  CUSTOM = ['all', 'cafe'].freeze
  has_many :positions, through: :permission_positions
  has_many :permission_positions
  validates :subject_class, :action, presence: true

  scope :by_subject, -> { order(subject_class: :asc) }

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
