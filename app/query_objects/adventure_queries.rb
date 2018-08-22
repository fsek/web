class AdventureQueries
  def self.highscore_list
    AdventureMissionGroup.select('groups.name, sum(points) AS total_points, count(points) AS finished_missions')
                         .joins({group: :introduction}, {adventure_mission: :adventure})
                         .where('introductions.current = true AND adventures.publish_results = true')
                         .group('groups.name')
                         .order('total_points')
  end
end
