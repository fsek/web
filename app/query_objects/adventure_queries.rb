class AdventureQueries
  def self.highscore_list
    AdventureMissionGroup.select('groups.name, sum(points) AS total_points, count(points) AS finished_missions')
                         .joins({group: :introduction}, {adventure_mission: :adventure})
                         .where('introductions.current = true AND adventures.publish_results = true AND adventure_mission_groups.pending = false')
                         .group('groups.name')
                         .order('total_points DESC, finished_missions DESC, groups.name ASC')
  end
end
