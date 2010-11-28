class AddDueDateToRecurringEntry < ActiveRecord::Migration
  def self.up
    add_column :recurring_entries, :due_date, :date
  end

  def self.down
    remove_column :recurring_entries, :due_date
  end
end
