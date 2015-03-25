# encoding: UTF-8
class Post < ActiveRecord::Base
  # Associations
  belongs_to :council
  has_and_belongs_to_many :profiles
  has_many :nominations
  has_many :candidates 
  has_many :permission_posts
  has_many :permissions, through: 'permission_posts'

  # Scopes
  scope :studierad, -> {where(elected_by: "Studierådet").order(council_id: :asc)}
  scope :termins, -> {where(elected_by: "Terminsmötet").order(council_id: :asc)}

  scope :not_termins, -> {where.not(elected_by: "Terminsmötet").order(council_id: :asc)}

  # Validations
  validates_presence_of :limit,:recLimit, :description

  # Scopes
  scope :renters, -> {where(car_rent:true)}
  
  def printLimit
    if((recLimit == 0) && (limit == 0)) || (recLimit > limit )
      "*"
    elsif(recLimit == limit) && (recLimit > 0)
      limit.to_s + " (x)"  
    elsif(limit > 0) && (recLimit == 0)
      limit.to_s         
    elsif(limit > recLimit)
      recLimit.to_s + "-" + limit.to_s        
    end
  end   
  def set_permissions(permissions)
    permissions.each do |id|
      #find the main permission assigned from the UI
      permission = Permission.find(id)
      self.permissions << permission
    end
  end
end
