class RemoveDueDateFromRecurringEntry < ActiveRecord::Migration
  def self.up
    remove_column :recurring_entries, :due_date
  end

  def self.down
    add_column :recurring_entries, :due_date, :date
  end
end
