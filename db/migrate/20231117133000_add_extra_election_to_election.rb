class AddExtraElectionToElection < ActiveRecord::Migration[5.1]
  def change
    add_column :elections, :close_extra, :datetime
  end
end
