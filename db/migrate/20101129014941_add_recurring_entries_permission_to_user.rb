class AddRecurringEntriesPermissionToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :recurring_entries_permission, :string
  end

  def self.down
    remove_column :users, :recurring_entries_permission
  end
end
