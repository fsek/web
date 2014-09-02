class CreateCouncils < ActiveRecord::Migration
  def change
    create_table :councils do |t|

      t.string    :title
      t.string    :url
      t.text      :description      
      t.integer    :president
      t.integer    :vicepresident
      t.string    :epost
      t.attachment :logo
      t.boolean   :public,:default => true      
      t.timestamps      
    end
  end
end
