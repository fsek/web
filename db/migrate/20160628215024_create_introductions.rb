class CreateIntroductions < ActiveRecord::Migration
  def up
    create_table(:introductions) do |t|
      t.string :title, null: false, default: ''
      t.datetime :start, null: false
      t.datetime :stop, null: false
      t.string :slug, null: false, index: true
      t.text :description
      t.boolean :current, null: false, default: true
      t.datetime :deleted_at, index: true

      t.timestamps null: false
    end

    Introduction.create_translation_table!(title: :string, description: :text)
  end

  def down
    drop_table(:introductions)
    Introduction.drop_translation_table!
  end
end
