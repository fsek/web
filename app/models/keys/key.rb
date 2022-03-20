class Key < ApplicationRecord
  validates :name, :description, presence: true
  validates :total, numericality: {greater_than: 0, less_than_or_equal_to: 1000000}
  validates :free_count, numericality: {greater_than_or_equal_to: 0}
  has_many :key_users, dependent: :restrict_with_error
  has_many :users, through: :key_users

  def self.free
    @key = []
    Key.all.each do |k|
      if k.free_count.positive?
        @key.push(k)
      end
    end
    @key
  end

  def users
    renters = []
    key_users.each do |key_user|
      renters.push(key_user.user.to_s)
    end
    renters.uniq.join(", ")
  end

  def free_count
    total - key_users.size
  end

  def to_s
    name.to_s
  end

  def to_s_and_free
    to_s + " (Antal lediga: " + free_count.to_s + ")"
  end
end
