class CreateElections < ActiveRecord::Migration
  def change
    create_table :elections do |t|
      t.datetime :start
      t.datetime :end
      t.boolean :visible
      t.string :url
      t.string :title
      t.text :description

      t.timestamps
    end
  end
end
