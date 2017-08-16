namespace 'event' do
  require 'csv'

  desc('Import events for Introduction through csv')
  task(introduction: :environment) do
    file = File.join(Rails.root, 'lib', 'assets', 'introduction_events.csv')
    unless File.exists?(file)
      puts "No CSV-file found, place it in #{file}"
      return
    end
    event_count = Event.count
    updated_count = 0
    category = Category.find_by(slug: :nollning)

    CSV.foreach(file, headers: true) do |row|
      event_hash = row.to_hash

      starts_at = Time.zone.parse(event_hash['starts_at'])
      ends_at = Time.zone.parse(event_hash['ends_at'])
      event = Event.translations.slug(:nollning).find_or_initialize_by(starts_at: starts_at, ends_at: ends_at)

      unless event.update(event_hash)
        puts "#{event_hash[:title]} could not be saved because: #{event.errors.to_h.to_s}"
        puts "------------------"
      else
        event.categories << Category.find_by(slug: :nollning) unless event.categories.include?(category)
        event.save!
        updated_count += 1
      end
    end
    event_count = Event.count - event_count

    puts "Created #{event_count} and updated #{updated_count - event_count}"
  end
end
