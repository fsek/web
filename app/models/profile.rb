class Profile < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :posts
  has_many :candidates
  has_many :rents  
  
  has_attached_file :avatar, 
                    :styles => { medium: "300x300>", thumb:  "100x100>" },
                    :path => ":rails_root/storage/profile/:id/:style/:filename"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  validates_presence_of :name, :lastname, on: :update
  validates_inclusion_of :start_year, in: 1954..(Time.zone.today.year+1)

  # Check if profile has user data
  def has_profile_data?
    return (self.name? && self.lastname?)
  end

  # Returns true if profile is fresh
  # /d.wessman
  def fresh?
    return self.created_at == self.updated_at
  end

  # Returns true if user is equal to profiles user
  # /d.wessman
  def owner?(user)
    (self.user == user)
  end

  # Check if user has post, and in that case what first_post is set to
  # /d.wessman
  def check_posts
      if(self.posts.count > 0) && (self.first_post?)
        return
      end
      if(self.posts.count > 0)
        self.first_post = self.posts.first.id
        self.save
      end
  end

  def print
    if (self.name) && (self.lastname)
      %(#{self.name} #{self.lastname})
    elsif (self.name)
      self.name
    end
  end
end
