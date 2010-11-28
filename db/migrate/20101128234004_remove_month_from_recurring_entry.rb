class RemoveMonthFromRecurringEntry < ActiveRecord::Migration
  def self.up
    remove_column :recurring_entries, :month
  end

  def self.down
    add_column :recurring_entries, :month, :integer
  end
end
