class AddClosingDateToElection < ActiveRecord::Migration
  def change
    add_column :elections, :closing, :datetime
  end
end
