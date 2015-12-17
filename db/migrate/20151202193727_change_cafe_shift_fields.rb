class ChangeCafeShiftFields < ActiveRecord::Migration
  def change
    remove_column :cafe_shifts, :firstname, :string
    remove_column :cafe_shifts, :lastname, :string
    remove_column :cafe_shifts, :name, :string
    remove_column :cafe_shifts, :phone, :string
    remove_column :cafe_shifts, :email, :string
    remove_column :cafe_shifts, :access_code, :string
    remove_column :cafe_shifts, :d_year, :string

    # Going to be moved to Worker, but contains info on production
    rename_column :cafe_shifts, :utskottskamp, :competition

    add_column :cafe_shifts, :cafe_worker_id, :integer
    add_index :cafe_shifts, :cafe_worker_id
  end
end
