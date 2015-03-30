class CreateNotices < ActiveRecord::Migration
  def change
    create_table :notices do |t|
      t.string      :title
      t.text        :description
      t.boolean     :public
      t.date        :d_publish
      t.date        :d_remove
      t.integer     :sort
      t.attachment  :image
      t.timestamps
    end
  end
end
