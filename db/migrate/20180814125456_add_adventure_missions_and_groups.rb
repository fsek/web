class AddAdventureMissionsAndGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :adventure_missions do |t|
      t.string :title
      t.text :description
      t.integer :max_points
      t.boolean :variable_points, default: false
      t.integer :index
      t.references :adventure, foreign_key: true, null: false
      t.timestamps
    end

    create_table :adventure_mission_groups do |t|
      t.integer :points, null: false
      t.datetime :finished
      t.references :adventure_mission, foreign_key: true, null: false
      t.references :group, foreign_key: true, null: false
      t.timestamps
    end

    remove_column :adventures, :max_points, :integer
  end
end
