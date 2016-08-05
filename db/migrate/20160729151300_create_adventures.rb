class CreateAdventures < ActiveRecord::Migration
  def change
    create_table :adventures do |t|
      t.string :title
      t.text :content
      t.integer :max_points, null: false
      t.references :introduction, index: true, foreign_key: true
      t.boolean :publish_results, null: false, default: false
      t.datetime :start_date, index: true
      t.datetime :end_date, index: true
      t.datetime :deleted_at, index: true

      t.timestamps null: false
    end
  end
end
