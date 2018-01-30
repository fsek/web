class MailAlias < ApplicationRecord
  VALID_DOMAINS = [ 'fsektionen.se',
                    'fsek.lth.se',
                    'farad.nu' ]

  validates :username, :domain, :target, :presence => true
  validates :username, :format => /\A[A-Za-z0-9_.+-]+\z/
  validates :username, :uniqueness => { :scope => [ :domain, :target ] }
  validates :domain, :inclusion => VALID_DOMAINS
  validates :target, :format => /\A[A-Za-z0-9_.+-]+@[A-Za-z0-9_.+-]+\z/

  scope :fulltext_search, -> (str) do
    (username, domain) = str.split('@', 2)
    if domain.present?
      return where('(username = ? and domain = ?) or target = ?',
                   username, domain, str)
    elsif username.present?
      return where('username like ?', "%#{username}%")
    else
      return all
    end
  end

  def self.insert_aliases! username, domain, targets
    # Update the alias to contain only those targets given.
    self.transaction do
      base_scope = MailAlias.where 'username = ? and domain = ?', username, domain

      if targets.empty?
        base_scope.delete_all # Not validated
        return MailAlias.none
      end

      # The queries below only work if targets != []

      to_remove = base_scope.where 'target not in (?)', targets
      to_remove.delete_all # Not validated

      existing = base_scope.where 'target in (?)', targets
      existing.update_all :updated_at => Time.zone.now # Not validated

      existing_targets = existing.pluck(:target)

      to_create = targets.reject{ |t| existing_targets.include? t }
      to_create.each do |t|
        MailAlias.create! :username => username, :domain => domain, :target => t
      end

      return base_scope.reload
    end
  end

  def address
    "#{username}@#{domain}"
  end
end
