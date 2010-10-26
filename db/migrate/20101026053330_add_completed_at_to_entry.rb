class AddCompletedAtToEntry < ActiveRecord::Migration
  def self.up
    add_column :entries, :completed_at, :datetime
  end

  def self.down
    remove_column :entries, :completed_at
  end
end
