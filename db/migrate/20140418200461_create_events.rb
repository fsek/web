class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      
      t.string :title
      t.string :author
      t.text :description      
      t.string :location
      t.datetime :starts_at
      t.datetime :ends_at
      t.boolean :all_day
      t.string :category      
      t.datetime :created_at
      t.datetime :updated_at
      t.attachment :image
      t.timestamps
    end
  end
end
