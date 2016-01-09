class CafeQueries
  # returns: all users who worked during study period(lp) and year
  def self.working_users(lp, year)
    join_cafe_shifts(User.joins(:cafe_shifts), lp, year).includes(:cafe_workers).uniq
  end

  # returns: all cafe_workers from study period and year
  def self.cafe_workers(lp, year)
    join_cafe_shifts(CafeWorker.joins(:cafe_shift), lp, year)
  end

  def self.highscore_groups(lp, year)
    (join_cafe_shifts(CafeWorker.select('cafe_workers.group as title, count(*) as score').
                     joins(:cafe_shift), lp, year).
    group('group') +
    join_cafe_shifts(Council.select('councils.title,  count(*) as score').
                     joins(:cafe_shifts), lp, year).
    group('council_id')).sort_by{ |g| -g[:score] }
  end

  def self.highscore(lp, year)
    join_cafe_shifts(User.select('users.id, users.firstname, users.lastname, count(*) as score').
                     joins(:cafe_shifts), lp, year).
    group('user_id').
    order('score desc').
    limit(10)
  end

  def self.free_shifts(lp, year)
    CafeShift.where(lp: lp).
      where('start > ? and year(start) = ?', Time.zone.now, year.year).
      without_worker
  end

  def self.for_day(day)
    between(day.beginning_of_day, day.end_of_day)
  end

  def self.between(start, stop)
    CafeShift.where('start BETWEEN ? AND ?', start, stop).
      order(pass: :asc).
      includes(:user)
  end

  private

  # If past year, give end of year
  # If current year, give end of day
  def self.year_or_today(year)
    if year.end_of_year > Time.zone.now.end_of_day
      Time.zone.now.end_of_day
    else
      year.end_of_year
    end
  end

  # Join with cafe shifts in given study period(lp) and year
  def self.join_cafe_shifts(join, lp, year)
    join.where(cafe_shifts: { lp: lp }).
      where('cafe_shifts.start > ?', year.beginning_of_year).
      where('cafe_shifts.start < ?', year_or_today(year))
  end
end
