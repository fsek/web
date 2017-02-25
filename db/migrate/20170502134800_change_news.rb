class ChangeNews < ActiveRecord::Migration
  def up
    add_column(:news, :pinned_from, :datetime)
    add_column(:news, :pinned_to, :datetime)
    remove_column(:news, :url)
  end

  def down
    add_column(:news, :url, :string)
    remove_column(:news, :pinned_from)
    remove_column(:news, :pinned_to)
  end
end
