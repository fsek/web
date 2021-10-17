class AdventureMissionService
  def self.shift_index_on_create(adventure, index)
    if adventure.adventure_missions.pluck(:index).include?(index)
      AdventureMission.where(adventure: adventure)
        .order(index: "desc")
        .limit(adventure.adventure_missions.count - index)
        .update_all("index = index + 1")
    end
  end

  def self.shift_index_on_destroy(adventure, index)
    if adventure.adventure_missions.pluck(:index).include?(index)
      AdventureMission.where(adventure: adventure)
        .order(index: "desc")
        .limit(adventure.adventure_missions.count - index)
        .update_all("index = index - 1")
    end
  end

  def self.shift_index_on_update(adventure, index_before, index_after)
    if adventure.adventure_missions.pluck(:index).include?(index_after)
      if index_before > index_after
        AdventureMission.where(adventure: adventure, id: AdventureMission.order(index: "desc")
        .limit(adventure.adventure_missions.count - index_after))
          .order(index: "asc")
          .limit(index_before - index_after)
          .update_all("index = index + 1")
      elsif index_before < index_after
        AdventureMission.where(adventure: adventure, id: AdventureMission.order(index: "desc")
        .limit(adventure.adventure_missions.count - index_before - 1))
          .order(index: "asc")
          .limit(index_after - index_before)
          .update_all("index = index - 1")
      end
    end
  end
end
