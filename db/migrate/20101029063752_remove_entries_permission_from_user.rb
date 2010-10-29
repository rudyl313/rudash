class RemoveEntriesPermissionFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :entries_permission
  end

  def self.down
    add_column :users, :entries_permission, :string
  end
end
