class ChangeSongs < ActiveRecord::Migration[5.0]
  def change
    add_column(:songs, :visits, :integer, default: 0)
  end
end
