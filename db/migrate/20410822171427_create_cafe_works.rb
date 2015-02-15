class CreateCafeWorks < ActiveRecord::Migration
  def change
    create_table :cafe_works do |t|
      t.datetime  :work_day
      t.integer   :pass
      t.integer   :lp
      t.integer   :lv
      t.integer   :profile_id      
      t.string    :name
      t.string    :lastname
      t.string    :phone      
      t.string    :email
      t.boolean   :utskottskamp
      t.string    :access_code
      t.integer   :d_year      
      t.timestamps
    end
  end
end
