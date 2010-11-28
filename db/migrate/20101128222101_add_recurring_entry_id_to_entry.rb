class AddRecurringEntryIdToEntry < ActiveRecord::Migration
  def self.up
    add_column :entries, :recurring_entry_id, :integer
  end

  def self.down
    remove_column :entries, :recurring_entry_id
  end
end
