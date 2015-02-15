class AddCafeWorksCouncils < ActiveRecord::Migration
  def change
    create_table "cafe_works_councils", id: false do |t|
        t.integer "cafe_work_id"
        t.integer "council_id"
    end
  end
end
