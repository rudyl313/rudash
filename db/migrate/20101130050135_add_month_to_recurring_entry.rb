class AddMonthToRecurringEntry < ActiveRecord::Migration
  def self.up
    add_column :recurring_entries, :month, :integer
  end

  def self.down
    remove_column :recurring_entries, :month
  end
end
