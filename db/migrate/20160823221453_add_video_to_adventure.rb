class AddVideoToAdventure < ActiveRecord::Migration
  def change
    add_column :adventures, :video, :string
  end
end
