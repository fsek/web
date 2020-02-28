class LockerRenterService
  def self.schedule_remove(locker_renter)
    return unless locker_renter.present?
      schedule_remove_unpaid(locker_renter)
      schedule_remove_done(locker_renter)
  end

  def self.schedule_remove_unpaid(locker_renter)
    semester = locker_renter.semester
    half_year = semester.slice(0,1)
    translated_date = ""

    if half_year == "VT"
      translated_date = "15 02"
    else
      translated_date = "15 09"
    end

    pay_deadline = translated_date + semester.slice(2..-1)
    pay_deadline = Time.strptime(pay_deadline, '%d %m %Y')
    LockerRenterDestroyUnpaidWorker.perform_at(pay_deadline, locker_renter.id)
  end

  def self.schedule_remove_done(locker_renter)
    semester = locker_renter.semester
    half_year = semester.slice(0,1)
    translated_date = ""

    if half_year == "VT"
      translated_date = "30 06"
    else
      translated_date = "30 12"
    end

    end_date = translated_date + semester.slice(2..-1)
    end_date = Time.strptime(end_date, '%d %m %Y')
    LockerRenterDestroyWorker.perform_at(end_date, locker_renter.id)
  end

  def self.destroy_locker_renter(locker_renter)
    locker_renter.locker.update(occupied: false)
    locker_renter.destroy!
  end

end
