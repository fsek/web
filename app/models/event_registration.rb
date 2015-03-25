# encoding:UTF-8
class EventRegistration < ActiveRecord::Base
	belongs_to :event
	belongs_to :profile
	validates_uniqueness_of :event_id,  scope: :profile_id, message: "En registrering finns redan för denna användaren. Du kan hitta den under din profil."
end
