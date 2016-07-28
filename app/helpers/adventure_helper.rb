module AdventureHelper
  def adventure_info(adventure)
    "#{date_range(adventure.start_date, adventure.end_date)},
     #{adventure.max_points}
     #{AdventureGroup.human_attribute_name(:points)}"
  end
end
