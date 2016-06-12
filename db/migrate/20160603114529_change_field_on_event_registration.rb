class ChangeFieldOnEventRegistration < ActiveRecord::Migration
  def change
    change_column_default(:event_registrations, :reserve, false)
    change_column_null(:event_registrations, :reserve, :false)
    add_column(:event_registrations, :answer, :text)
    remove_column(:event_registrations, :removed_at, :datetime)
    remove_column(:event_registrations, :remover_id, :integer)
    remove_column(:event_registrations, :comment, :text)
  end
end
