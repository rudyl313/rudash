class RemoveTypeFromEntry < ActiveRecord::Migration
  def self.up
    remove_column :entries, :type
  end

  def self.down
    add_column :entries, :type, :string
  end
end
