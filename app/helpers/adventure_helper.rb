module AdventureHelper
  def adventure_info(adventure)
    date_range(adventure.start_date, adventure.end_date).to_s
  end
end
