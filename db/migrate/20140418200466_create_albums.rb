class CreateAlbums < ActiveRecord::Migration
  def change
    create_table :albums do |t|
      t.string :title
      t.text :description
      t.string :author
      t.string :location
      t.boolean :public
      t.datetime :start_date
      t.datetime :end_date
      t.timestamps
    end
  end
end
