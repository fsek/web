class AddCouncilIdToPage < ActiveRecord::Migration
  def change
    add_column :pages,:council_id,:integer
  end
end
