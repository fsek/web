class Profile < ActiveRecord::Base
  belongs_to :user
  has_and_belongs_to_many :posts
  has_many :candidates  
  
  has_attached_file :avatar, 
                    :styles => { original: "800x800>", medium: "300x300>", thumb:  "100x100>" },                   
                    :path => ":rails_root/public/system/images/profil/:id/:style/:filename",
                    :url => "/system/images/profil/:id/:style/:filename"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/ 
  

  def namn
    self.name || self.user.username
  end
  def to_s
    if(self.first_post)
      post = Post.find_by_id(self.first_post)
    end
    if (self.name) && (post)
      self.name + ' (' + post.title + ')'
    elsif (self.name)
      self.name
    end
  end

end
