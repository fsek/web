require 'uri'

class ShortLink < ApplicationRecord
  validates :link, :target, :presence => true
  validates :link, :uniqueness => true
  validates :link, :format => /\A[a-z0-9_-]+\z/
  validates :link, :exclusion => { :in => RoutePrefixes::PREFIXES }

  validate -> do # target is a valid url
    begin
      # require u to be valid uri
      u = URI.parse target
      # require u to have at least two host components (google.com not google)
      if u.host !~ /\./
        fail URI::InvalidURIError
      end
    rescue URI::InvalidURIError
      errors.add :target, I18n.t('model.short_link.invalid_url')
    end
  end

  def link= val
    self[:link] = val.to_s.downcase
  end

  def target= val
    # automatically tack on http:// if scheme is missing
    self[:target] =
      if val.present? && val.to_s !~ /\A\w+:\/\//
        "http://#{val}"
      else
        val
      end
  end

  def self.lookup link
    find_by_link! link
  end
end
