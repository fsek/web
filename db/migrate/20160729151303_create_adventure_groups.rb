class CreateAdventureGroups < ActiveRecord::Migration
  def change
    create_table :adventure_groups do |t|
      t.integer :points, null: false, default: 0
      t.references :adventure, index: true, foreign_key: true
      t.references :group, index: true, foreign_key: true
      t.datetime :deleted_at, index: true

      t.timestamps null: false
    end
  end
end
