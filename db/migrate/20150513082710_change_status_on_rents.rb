class ChangeStatusOnRents < ActiveRecord::Migration
  def up
    change_column_default(:rents, :status, nil)
    # Should this be done in raw SQL or smth instead?
    # d.wessman 2015-05-13
    Rent.find_each do |rent|
      if rent.status == 'Ej bestämd' || rent.status == 'Ej bestÃƒÂ¤md'
        rent.status == :unconfirmed
      elsif rent.status == 'Bekräftad'
        rent.status == :confirmed
      else
        rent.status == :denied
      end
    end
  end

  def down
    update_column :rents, :status, :string, default: 'Ej bestämd'
  end
end
