class CafeCompetition
  attr_accessor :cafe_workers, :lp, :users, :lps, :year, :years
  def initialize(cafe_workers, users, lp, year)
    @cafe_workers = cafe_workers
    @lp = lp
    @users = users
    @lps = ['1', '2', '3', '4'] - [lp]
    @year = year.year
    @free_shifts = CafeQueries.free_shifts(lp, year)
    @highscore = CafeQueries.highscore(lp, year)
    @highscore_group = CafeQueries.highscore_groups(lp, year)
  end

  def count
    cafe_workers.count
  end

  def user_count
    users.count
  end

  def highscore
    @highscore
  end

  def has_highscore?
    @highscore.exists?
  end

  def has_highscore_group?
    @highscore_group.count > 0
  end

  def highscore_group
    @highscore_group
  end

  def study_periods
    ['1', '2', '3', '4'] - [lp]
  end

  def years
    (2015..(Time.zone.now.year + 1)).to_a - [year]
  end

  def free_shifts
    { count: @free_shifts.count, free: @free_shifts.first }
  end
end
