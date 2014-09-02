class AddCouncilIdToPost < ActiveRecord::Migration
  def change
    add_column :posts, :council_id, :integer
  end
end
