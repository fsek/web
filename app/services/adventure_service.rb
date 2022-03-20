class AdventureService
  # Schedule locking of the adventure missions belonging to this adventure
  def self.schedule_locking(adventure)
    return unless adventure.present?
    schedule_unlock(adventure)
    schedule_lock(adventure)
  end

  def self.schedule_unlock(adventure)
    if adventure.start_date > Time.now
      AdventureMissionUnlockWorker.perform_at(adventure.start_date, adventure.id)
    end
  end

  def self.schedule_lock(adventure)
    if adventure.end_date > Time.now
      AdventureMissionLockWorker.perform_at(adventure.end_date, adventure.id)
    end
  end

  def self.lock_adventure_missions(adventure, locked)
    adventure_missions = adventure.adventure_missions
    adventure_missions.update_all(locked: locked) unless adventure_missions.empty?
  end

  def self.adventure_active(adventure)
    adventure.start_date < Time.now && adventure.end_date > Time.now
  end

  def self.update_locking(old_adventure, new_adventure)
    # Unlock/lock if adventure is active/inactive and create new workers if its dates have been changed
    if adventure_active(new_adventure)
      lock_adventure_missions(new_adventure, false)
    else
      lock_adventure_missions(new_adventure, true)
    end
    if old_adventure.start_date != new_adventure.start_date && old_adventure.end_date != new_adventure.end_date
      schedule_locking(new_adventure)
    elsif old_adventure.start_date != new_adventure.start_date
      schedule_unlock(new_adventure)
    elsif old_adventure.end_date != new_adventure.end_date
      schedule_lock(new_adventure)
    end
  end
end
