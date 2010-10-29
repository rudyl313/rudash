class AddFieldsToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :users_permission, :string
    add_column :users, :entries_permission, :string
  end

  def self.down
    remove_column :users, :entries_permission
    remove_column :users, :users_permission
  end
end
