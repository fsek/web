class EventCreator
  def event(title, location, description, starts_at, ends_at)
    Event.new(category: :nollning, title: title, location: location,
              description: description, starts_at: starts_at, ends_at: ends_at)
  end
end

namespace :db do
  desc 'Skapar nollnings event för 2015'
  task(nollning_event: :environment) do
    CSV.foreach(Rails.root.join('lib','tasks','nollnings_dates.csv')) do |row|
      Event.find_or_create_by!(starts_at: row[0], ends_at: row[1], title: row[2], location: row[3], description: row[4], signup: row[5], food: row[6], drink: row[7], cash: row[8])
    end
    
    # Måndag 24/8
   # date = Time.zone.parse("2015-08-24 00:00:00")
   # event = e.event("Hälsningsanförande",
   #                 "Kårhusets Aula",
   #                 "Rektorns hälsningsanförande. Rektorn hälsar alla nya studenter välkomna till LTH",
   #                 date + 10.hours + 30.minutes, date + 11.hour + 30.minutes)
   # Event.find_or_create_by!(event.attributes)

  end
end

