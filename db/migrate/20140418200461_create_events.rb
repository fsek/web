class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      
      t.string :title
      t.string :author
      t.text :content
      t.text :summary
      t.string :location
      t.datetime :date
      t.datetime :end_date
      t.boolean :dayevent
      t.string :category      
      t.datetime :created_at
      t.datetime :updated_at
      t.attachment :image
      t.timestamps
    end
  end
end
