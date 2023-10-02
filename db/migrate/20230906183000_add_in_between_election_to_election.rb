class AddInBetweenElectionToElection < ActiveRecord::Migration[5.1]
  def change
    add_column :elections, :close_in_between, :datetime
  end
end
